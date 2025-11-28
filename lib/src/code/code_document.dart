import 'dart:async';

import 'package:kalua/src/code/piece_table.dart';

class CodeDocument {
  CodeDocument(String text) : _pieceTable = PieceTable(text), _lineStarts = [0] {
    _rebuildLineIndex();
  }

  final PieceTable _pieceTable;
  final List<int> _lineStarts;

  // ---------------- High-level public API ----------------

  String get text => _pieceTable.getText();
  int get length => _pieceTable.length;

  void insert(int offset, String text) {
    _pieceTable.insert(offset, text);
    _updateLineIndexIncremental(offset, 0, text);
    _recordEdit(_InsertAction(offset, text));

    _startBatchTimer();
  }

  void delete({required int offset, required int count}) {
    final deletedText = text.substring(offset, offset + count);
    _pieceTable.delete(offset: offset, count: count);
    _updateLineIndexIncremental(offset, count, '');
    _recordEdit(_DeleteAction(offset, deletedText));

    _startBatchTimer();
  }

  (int line, int column) offsetToLineColumn(int offset) {
    final lineIndex = _findLineIndex(offset);
    return (lineIndex, offset - _lineStarts[lineIndex]);
  }

  int lineColumnToOffset(int line, int column) => _lineStarts[line] + column;

  int get lineCount => _lineStarts.length;
  int getLineStart(int line) => _lineStarts[line];

  // ----- Undo/redo ------
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void undo() {
    _commitPendingBatch();
    if (!canUndo) return;
    final action = _undoStack.removeLast();
    action.undo(this);
    _redoStack.add(action);
  }

  void redo() {
    _commitPendingBatch();
    if (!canRedo) return;
    final action = _redoStack.removeLast();
    action.redo(this);
    _undoStack.add(action);
  }

  void _commitPendingBatch() {
    if (_pendingBatch != null) {
      _undoStack.add(_pendingBatch!);
      _redoStack.clear();
      _pendingBatch = null;
      _batchTimer?.cancel();
    }
  }

  final List<_EditAction> _undoStack = [];
  final List<_EditAction> _redoStack = [];
  bool _suppressingHistory = false;

  static const _batchInterval = Duration(milliseconds: 750);
  _EditAction? _pendingBatch;
  DateTime? _lastEditTime;
  Timer? _batchTimer;

  void _startBatchTimer() {
    _batchTimer?.cancel();
    _batchTimer = Timer(_batchInterval, () {
      _commitPendingBatch();
    });
  }

  void _recordEdit(_EditAction action) {
    if (_suppressingHistory) return;

    final now = DateTime.now();
    final shouldBatch =
        _pendingBatch != null &&
        action.canBatchWith(_pendingBatch!) &&
        _lastEditTime != null &&
        now.difference(_lastEditTime!) < _batchInterval;

    if (shouldBatch) {
      // Merge into existing batch
      _pendingBatch = _pendingBatch!.appendAtEnd(action);
    } else {
      // Commit previous batch if exists
      if (_pendingBatch != null) {
        _undoStack.add(_pendingBatch!);
        _redoStack.clear();
      }
      _pendingBatch = action;
    }

    _lastEditTime = now;
  }

  void _suppressHistory(void Function() callback) {
    final previous = _suppressingHistory;
    _suppressingHistory = true;
    try {
      callback();
    } finally {
      _suppressingHistory = previous;
    }
  }
  // ----- END undo/redo ----

  void _rebuildLineIndex() {
    _lineStarts.clear();
    _lineStarts.add(0);

    int offset = 0;
    for (final piece in _pieceTable.pieces) {
      final text = _pieceTable.readPiece(piece);
      for (int i = 0; i < text.length; i++) {
        if (text.codeUnitAt(i) == 0x0A) _lineStarts.add(offset + i + 1);
      }
      offset += text.length;
    }
  }

  void _updateLineIndexIncremental(int start, int deletedLength, String insertedText) {
    final oldEnd = start + deletedLength;
    final delta = insertedText.length - deletedLength;

    final startLine = _findLineIndex(start);
    final endLine = _findLineIndex(oldEnd);

    _lineStarts.removeRange(startLine + 1, endLine + 1);

    int insertPos = startLine;
    for (int i = 0; i < insertedText.length; i++) {
      if (insertedText.codeUnitAt(i) == 0x0A) {
        insertPos++;
        _lineStarts.insert(insertPos, start + i + 1);
      }
    }

    if (delta != 0) {
      for (int i = insertPos + 1; i < _lineStarts.length; i++) {
        _lineStarts[i] += delta;
      }
    }
  }

  int _findLineIndex(int offset) {
    int low = 0;
    int high = _lineStarts.length - 1;
    while (low <= high) {
      final mid = (low + high) >> 1;
      final midVal = _lineStarts[mid];
      if (midVal == offset) return mid;
      if (midVal < offset)
        low = mid + 1;
      else
        high = mid - 1;
    }
    return low - 1;
  }
}

class _InsertAction implements _EditAction {
  _InsertAction(this.offset, this.text);

  final int offset;
  final String text;

  @override
  bool canBatchWith(_EditAction existingBatch) {
    if (existingBatch is! _InsertAction) return false;

    // Must be adjacent and forward-contiguous
    return existingBatch.offset + existingBatch.text.length == offset;
  }

  @override
  _EditAction appendAtEnd(_EditAction actionToAppend) {
    final newInsertion = actionToAppend as _InsertAction;
    return _InsertAction(offset, text + newInsertion.text);
  }

  @override
  void undo(CodeDocument doc) {
    doc._suppressHistory(() => doc.delete(offset: offset, count: text.length));
  }

  @override
  void redo(CodeDocument doc) {
    doc._suppressHistory(() => doc.insert(offset, text));
  }

  @override
  String toString() => '[InsertAction] - at $offset: "$text"';
}

class _DeleteAction implements _EditAction {
  _DeleteAction(this.offset, this.text);

  final int offset;
  final String text;

  @override
  bool canBatchWith(_EditAction existingBatch) {
    if (existingBatch is! _DeleteAction) return false;

    // Only batch with deletions that deleted text immediately preceding
    // this existing delete actions deletion. E.g., "abcd", delete "d", can
    // then batch with delete "bc". But, delete "d" cannot batch with delete "b".
    return offset == existingBatch.offset - text.length;
  }

  @override
  _EditAction appendAtEnd(_EditAction actionToAppend) {
    final newDeletion = actionToAppend as _DeleteAction;
    return _DeleteAction(newDeletion.offset, newDeletion.text + text);
  }

  @override
  void undo(CodeDocument doc) {
    doc._suppressHistory(() => doc.insert(offset, text));
  }

  @override
  void redo(CodeDocument doc) {
    doc._suppressHistory(() => doc.delete(offset: offset, count: text.length));
  }

  @override
  String toString() => '[DeleteAction] - at $offset: "$text"';
}

abstract class _EditAction {
  void undo(CodeDocument doc);
  void redo(CodeDocument doc);

  bool canBatchWith(_EditAction existingBatch) => false;

  _EditAction appendAtEnd(_EditAction actionToAppend) => throw UnsupportedError('Cannot merge actions');
}
