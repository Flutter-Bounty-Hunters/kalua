import 'package:fake_async/fake_async.dart';
import 'package:kalua/kalua.dart';
import 'package:test/test.dart';

void main() {
  group('CodeDocument undo/redo – basic', () {
    test('insert and undo (single action)', () {
      fakeAsync((async) {
        final doc = CodeDocument('');
        doc.insert(0, 'hello');
        async.elapse(const Duration(milliseconds: 751)); // end batch

        expect(doc.text, 'hello');
        expect(doc.canUndo, true);
        expect(doc.canRedo, false);

        doc.undo();
        expect(doc.text, '');
        expect(doc.canUndo, false);
        expect(doc.canRedo, true);

        doc.redo();
        expect(doc.text, 'hello');
        expect(doc.canUndo, true);
        expect(doc.canRedo, false);
      });
    });

    test('delete and undo', () {
      fakeAsync((async) {
        final doc = CodeDocument('abcdef');
        doc.delete(offset: 2, count: 3); // delete cde
        async.elapse(const Duration(milliseconds: 501));

        expect(doc.text, 'abf');

        doc.undo();
        expect(doc.text, 'abcdef');

        doc.redo();
        expect(doc.text, 'abf');
      });
    });

    test('undo/redo multiple independent steps', () {
      fakeAsync((async) {
        final doc = CodeDocument('');

        doc.insert(0, 'a');
        async.elapse(const Duration(milliseconds: 751));

        doc.insert(1, 'b');
        async.elapse(const Duration(milliseconds: 751));

        doc.insert(2, 'c');
        async.elapse(const Duration(milliseconds: 751));

        expect(doc.text, 'abc');

        doc.undo();
        expect(doc.text, 'ab');

        doc.undo();
        expect(doc.text, 'a');

        doc.undo();
        expect(doc.text, '');

        expect(doc.canUndo, false);

        doc.redo();
        expect(doc.text, 'a');

        doc.redo();
        expect(doc.text, 'ab');

        doc.redo();
        expect(doc.text, 'abc');

        expect(doc.canRedo, false);
      });
    });
  });

  group('CodeDocument undo/redo – batching behavior', () {
    test('typing letters quickly batches into one undo step', () {
      fakeAsync((async) {
        final doc = CodeDocument('');

        doc.insert(0, 'h');
        async.elapse(const Duration(milliseconds: 100));

        doc.insert(1, 'e');
        async.elapse(const Duration(milliseconds: 100));

        doc.insert(2, 'l');
        async.elapse(const Duration(milliseconds: 100));

        doc.insert(3, 'l');
        async.elapse(const Duration(milliseconds: 100));

        doc.insert(4, 'o');

        // Now end the batch
        async.elapse(const Duration(milliseconds: 751));

        expect(doc.text, 'hello');
        expect(doc.canUndo, true);

        // One undo removes all 5 inserts
        doc.undo();
        expect(doc.text, '');
      });
    });

    test('pause between letters ends batch (two undo steps)', () {
      fakeAsync((async) {
        final doc = CodeDocument('');

        doc.insert(0, 'h');
        async.elapse(const Duration(milliseconds: 751)); // batch ends

        doc.insert(1, 'i');
        async.elapse(const Duration(milliseconds: 751)); // batch ends

        expect(doc.text, 'hi');

        doc.undo(); // undo 'i'
        expect(doc.text, 'h');

        doc.undo(); // undo 'h'
        expect(doc.text, '');
      });
    });

    test('delete batching: holding delete key batches deletes', () {
      fakeAsync((async) {
        final doc = CodeDocument('abcdef');

        doc.delete(offset: 5, count: 1); // delete f
        async.elapse(const Duration(milliseconds: 50));

        doc.delete(offset: 4, count: 1); // delete e
        async.elapse(const Duration(milliseconds: 50));

        doc.delete(offset: 3, count: 1); // delete d
        async.elapse(const Duration(milliseconds: 751)); // end batch

        expect(doc.text, 'abc');

        doc.undo(); // restore d,e,f
        expect(doc.text, 'abcdef');
      });
    });

    test('insert → delete should break batch (different action types)', () {
      fakeAsync((async) {
        final doc = CodeDocument('abc');

        doc.insert(3, 'X'); // abcX
        expect(doc.text, 'abcX');
        async.elapse(const Duration(milliseconds: 100));

        doc.delete(offset: 1, count: 1); // remove b → aXc
        expect(doc.text, 'acX');
        async.elapse(const Duration(milliseconds: 751));

        doc.undo(); // undo delete
        expect(doc.text, 'abcX');

        doc.undo(); // undo insert
        expect(doc.text, 'abc');
      });
    });
  });

  group('CodeDocument undo/redo – edge cases', () {
    test('undo when no history does nothing', () {
      fakeAsync((async) {
        final doc = CodeDocument('x');
        expect(doc.canUndo, false);

        doc.undo();
        expect(doc.text, 'x');
      });
    });

    test('redo when no redo history does nothing', () {
      fakeAsync((async) {
        final doc = CodeDocument('x');
        expect(doc.canRedo, false);

        doc.redo();
        expect(doc.text, 'x');
      });
    });

    test('inserts at start, end, middle are separate steps', () {
      fakeAsync((async) {
        final doc = CodeDocument('abc');

        doc.insert(0, 'X'); // Xabc
        async.elapse(const Duration(milliseconds: 501));

        doc.insert(4, 'Y'); // XabcY
        async.elapse(const Duration(milliseconds: 501));

        doc.insert(2, 'Z'); // XaZbcY
        async.elapse(const Duration(milliseconds: 501));

        expect(doc.text, 'XaZbcY');

        doc.undo();
        expect(doc.text, 'XabcY');

        doc.undo();
        expect(doc.text, 'Xabc');

        doc.undo();
        expect(doc.text, 'abc');

        doc.redo();
        expect(doc.text, 'Xabc');

        doc.redo();
        expect(doc.text, 'XabcY');

        doc.redo();
        expect(doc.text, 'XaZbcY');
      });
    });

    test('delete entire document and undo', () {
      fakeAsync((async) {
        final doc = CodeDocument('hello\nworld');
        doc.delete(offset: 0, count: doc.length);
        async.elapse(const Duration(milliseconds: 501));

        expect(doc.text, '');

        doc.undo();
        expect(doc.text, 'hello\nworld');

        doc.redo();
        expect(doc.text, '');
      });
    });

    test('multi-line insert/delete with undo/redo', () {
      fakeAsync((async) {
        final doc = CodeDocument('a\nb\nc');

        doc.insert(4, '\nX\nY');
        async.elapse(const Duration(milliseconds: 501));
        expect(doc.text, 'a\nb\n\nX\nYc');

        doc.delete(offset: 2, count: 3);
        async.elapse(const Duration(milliseconds: 501));
        expect(doc.text, 'a\nX\nYc');

        doc.undo();
        expect(doc.text, 'a\nb\n\nX\nYc');

        doc.undo();
        expect(doc.text, 'a\nb\nc');
      });
    });

    test('undo/redo after consecutive edits with batching between', () {
      fakeAsync((async) {
        final doc = CodeDocument('abc');

        doc.insert(3, '123'); // abc123
        async.elapse(const Duration(milliseconds: 501));

        doc.delete(offset: 1, count: 2); // a123
        async.elapse(const Duration(milliseconds: 501));

        expect(doc.text, 'a123');

        doc.undo(); // undo delete → abc123
        expect(doc.text, 'abc123');

        doc.undo(); // undo insert → abc
        expect(doc.text, 'abc');

        doc.redo(); // redo insert
        expect(doc.text, 'abc123');

        doc.redo(); // redo delete
        expect(doc.text, 'a123');
      });
    });
  });

  group('CodeDocument undo/redo – line/column correctness', () {
    test('offsetToLineColumn stays correct after undo/redo', () {
      fakeAsync((async) {
        final doc = CodeDocument('a\nb\nc');

        doc.insert(1, 'X\nY');
        async.elapse(const Duration(milliseconds: 501));

        expect(doc.text, 'aX\nY\nb\nc');
        expect(doc.offsetToLineColumn(0), (0, 0));
        expect(doc.offsetToLineColumn(3), (1, 0));
        expect(doc.offsetToLineColumn(5), (2, 0));

        doc.undo();
        expect(doc.text, 'a\nb\nc');
        expect(doc.offsetToLineColumn(0), (0, 0));
        expect(doc.offsetToLineColumn(2), (1, 0));
        expect(doc.offsetToLineColumn(4), (2, 0));

        doc.redo();
        expect(doc.text, 'aX\nY\nb\nc');
        expect(doc.offsetToLineColumn(0), (0, 0));
        expect(doc.offsetToLineColumn(3), (1, 0));
        expect(doc.offsetToLineColumn(5), (2, 0));
      });
    });
  });
}
