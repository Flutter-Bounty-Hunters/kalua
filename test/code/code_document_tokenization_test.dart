import 'dart:ui';

import 'package:kalua/kalua.dart';
import 'package:test/test.dart';

void main() {
  group('CodeDocument tokenization', () {
    late CodeDocument doc;

    setUp(() {
      doc = CodeDocument('')..tokenProvider = _FakeTokenProvider();
    });

    test('initial empty document produces zero tokens', () {
      expect(doc.tokens, isEmpty);
    });

    test('simple document tokenizes top-to-bottom', () {
      doc.replaceRange(0, 0, 'var x = 1;');
      expect(doc.text, 'var x = 1;');
      final tokens = doc.tokens;

      expect(tokens, isNotEmpty);
      expect(tokens.first.start, 0);
      expect(tokens.last.end, doc.length);
    });

    test('incremental tokenization only re-tokenizes changed region', () {
      final tokenProvider = doc.tokenProvider as _FakeTokenProvider;

      doc.replaceRange(0, 0, 'print("Hello");\nprint("World");');
      tokenProvider.resetStats();

      // Modify only "Hello" → "Hi"
      doc.replaceRange(7, 12, 'Hi');

      // Should have been called only once
      expect(tokenProvider.calls, 1);

      // Should have been called with minimal region
      expect(tokenProvider.recordedRegions.length, 1);
      final (start, end) = tokenProvider.recordedRegions.first;
      expect(start, 7);
      expect(end, 9);

      // And tokens outside that region should be identical objects
      final oldTokens = tokenProvider.lastFullTokensBeforeEdit;
      final newTokens = doc.tokens;

      final secondLineStart = doc.text.indexOf('\n') + 1;

      final oldSecond = oldTokens.where((t) => t.start >= secondLineStart);
      final newSecond = newTokens.where((t) => t.start >= secondLineStart);

      for (var i = 0; i < oldSecond.length && i < newSecond.length; i++) {
        expect(
          identical(oldSecond.elementAt(i), newSecond.elementAt(i)),
          isTrue,
          reason: 'Unchanged regions should preserve token objects',
        );
      }
    });

    test('token ranges shift correctly after an insertion', () {
      doc.replaceRange(0, 0, 'abc');
      expect(doc.tokens, [TokenSpan(0, 3, SyntaxKind.testToken)]);

      // Insert character at start of document.
      doc.replaceRange(0, 0, '[');
      doc.insert(doc.length, ']');
      expect(doc.text, '[abc]');

      expect(doc.tokens, [
        TokenSpan(0, 1, SyntaxKind.punctuation),
        TokenSpan(1, 3, SyntaxKind.testToken),
        TokenSpan(3, 4, SyntaxKind.punctuation),
      ]);
    });

    test('token ranges shrink correctly after deletion', () {
      doc.replaceRange(0, 0, 'abcdef');
      final before = List.of(doc.tokens);

      // Delete "cd"
      doc.replaceRange(2, 4, '');

      final after = doc.tokens;

      // Remaining tokens shift left by 2
      for (var i = 0; i < after.length; i++) {
        final a = after[i];
        final b = before[i + 1]; // token that used to follow the deletion region

        expect(a.start, equals(b.start - 2));
        expect(a.end, equals(b.end - 2));
      }
    });

    test('insertion in the middle of a token splits it or adjusts ranges', () {
      doc.replaceRange(0, 0, 'variable');

      final before = List.of(doc.tokens);
      final targetToken = before.first;

      // Insert in the middle
      doc.replaceRange(3, 3, '_part_');

      final after = doc.tokens;

      expect(after, isNotEmpty);

      // Ensure the token before the insertion remains
      expect(after.first.start, 0);

      // Ensure new or modified tokens exist around the insertion
      final newToken = after.firstWhere(
        (t) => t.start <= 3 && t.end >= 3 + '_part_'.length,
        orElse: () => throw Exception('Expected insertion-aware token'),
      );

      expect(newToken.start, equals(targetToken.start));
    });

    test('selection-aware highlighting returns only intersecting tokens', () {
      doc.replaceRange(0, 0, 'var example = 42;\nvar sample = 99;');

      // Select "example"
      final start = doc.text.indexOf('example');
      final end = start + 'example'.length;

      final selected = doc.tokensInRange(start, end);

      expect(selected, isNotEmpty);

      // All returned tokens must intersect the selection
      for (final t in selected) {
        expect(!(t.end <= start || t.start >= end), isTrue, reason: 'Token must intersect selection');
      }
    });

    test('selection-aware highlighting returns empty when nothing overlaps', () {
      doc.replaceRange(0, 0, 'var a = 1;\nvar b = 2;');

      // Select a region beyond document end
      final selected = doc.tokensInRange(1000, 1010);

      expect(selected, isEmpty);
    });

    test('tokenization handles large inserts without failing', () {
      final large = 'x' * 50000;
      doc.replaceRange(0, 0, large);

      expect(doc.tokens, isNotEmpty);
    });

    test('tokenization handles rapid consecutive edits', () {
      doc.replaceRange(0, 0, 'abc');
      doc.replaceRange(1, 2, 'ZZ');
      doc.replaceRange(0, 0, '---');
      doc.replaceRange(doc.length - 1, doc.length, '*');

      expect(doc.tokens, isNotEmpty);
      expect(doc.length, equals(doc.text.length));
    });
  });
}

class _FakeTokenProvider implements TokenProvider {
  /// Number of times tokenize() or tokenizePartial() has been called.
  int calls = 0;

  /// Records all partial-tokenization regions.
  final List<(int start, int end)> recordedRegions = [];

  /// Snapshot of tokens before the most recent edit.
  List<TokenSpan> lastFullTokensBeforeEdit = const [];

  /// Internal storage for last produced full-token list.
  List<TokenSpan> _lastTokens = const [];

  /// Reset counters and store the full-token snapshot.
  void resetStats() {
    calls = 0;
    recordedRegions.clear();
    lastFullTokensBeforeEdit = List.of(_lastTokens);
  }

  @override
  List<TokenSpan> tokenize(String fullText) {
    calls++;

    final tokens = <TokenSpan>[];

    int i = 0;
    while (i < fullText.length) {
      final code = fullText.codeUnitAt(i);

      if (_isWordChar(code)) {
        final start = i;
        while (i < fullText.length && _isWordChar(fullText.codeUnitAt(i))) i++;
        tokens.add(TokenSpan(start, i, SyntaxKind.testToken));
      } else if (_isPunctuation(code)) {
        tokens.add(TokenSpan(i, i + 1, SyntaxKind.punctuation));
        i++;
      } else {
        i++; // skip whitespace / unknown chars
      }
    }

    _lastTokens = tokens;
    return tokens;
  }

  @override
  List<TokenSpan>? tokenizePartial({required String fullText, required TextRange range}) {
    calls++;

    int start = range.start.clamp(0, fullText.length);
    int end = range.end.clamp(0, fullText.length);

    recordedRegions.add((start, end));

    // Extend start backward if inside a word
    while (start > 0 && _isWordChar(fullText.codeUnitAt(start - 1))) {
      start--;
    }

    // Extend end forward if inside a word
    while (end < fullText.length && _isWordChar(fullText.codeUnitAt(end))) {
      end++;
    }

    final tokens = <TokenSpan>[];
    int i = start;

    while (i < end) {
      final code = fullText.codeUnitAt(i);

      if (_isWordChar(code)) {
        final tStart = i;
        while (i < fullText.length && _isWordChar(fullText.codeUnitAt(i))) i++;
        tokens.add(TokenSpan(tStart, i, SyntaxKind.testToken));
      } else if (_isPunctuation(code)) {
        tokens.add(TokenSpan(i, i + 1, SyntaxKind.punctuation));
        i++;
      } else {
        i++; // skip whitespace / unknown chars
      }
    }

    return tokens;
  }

  bool _isWordChar(int code) {
    // ASCII letters and digits only
    return (code >= 0x30 && code <= 0x39) || // 0-9
        (code >= 0x41 && code <= 0x5A) || // A-Z
        (code >= 0x61 && code <= 0x7A); // a-z
  }

  bool _isPunctuation(int code) {
    const punctuations = [';', '=', '(', ')', '{', '}', '[', ']'];
    return punctuations.contains(String.fromCharCode(code));
  }
}
