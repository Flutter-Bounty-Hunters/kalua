import 'package:kalua/kalua.dart';
import 'package:test/test.dart';

void main() {
  group('CodeDocument – basic initialization', () {
    test('empty document initializes correctly', () {
      final doc = CodeDocument('');
      expect(doc.length, 0);
      expect(doc.text, '');
      expect(doc.offsetToLineColumn(0), (0, 0));
      expect(doc.lineColumnToOffset(0, 0), 0);
    });

    test('single-line document initializes correctly', () {
      final doc = CodeDocument('hello');
      expect(doc.length, 5);
      expect(doc.text, 'hello');
      expect(doc.offsetToLineColumn(0), (0, 0));
      expect(doc.offsetToLineColumn(4), (0, 4));
      expect(doc.lineColumnToOffset(0, 2), 2);
    });

    test('multi-line initialization', () {
      final doc = CodeDocument('a\nbb\nccc');
      //a\n
      //bb\n
      //ccc
      expect(doc.length, 8);
      expect(doc.offsetToLineColumn(0), (0, 0));
      expect(doc.offsetToLineColumn(1), (0, 1)); // '\n'
      expect(doc.offsetToLineColumn(2), (1, 0));
      expect(doc.offsetToLineColumn(3), (1, 1));
      expect(doc.offsetToLineColumn(5), (2, 0));
    });
  });

  // ---------------------------------------------------------------------------

  group('CodeDocument – insertion', () {
    test('insert into empty document', () {
      final doc = CodeDocument('');
      doc.insert(0, 'abc');
      expect(doc.text, 'abc');
      expect(doc.length, 3);
      expect(doc.offsetToLineColumn(2), (0, 2));
    });

    test('insert at beginning', () {
      final doc = CodeDocument('world');
      doc.insert(0, 'hello ');
      expect(doc.text, 'hello world');
      expect(doc.offsetToLineColumn(6), (0, 6));
    });

    test('insert in middle of piece', () {
      final doc = CodeDocument('abcdef');
      doc.insert(3, 'XYZ');
      expect(doc.text, 'abcXYZdef');
      expect(doc.length, 9);
      expect(doc.offsetToLineColumn(3), (0, 3));
      expect(doc.offsetToLineColumn(4), (0, 4));
    });

    test('insert at end', () {
      final doc = CodeDocument('abc');
      doc.insert(3, 'def');
      expect(doc.text, 'abcdef');
      expect(doc.lineColumnToOffset(0, 5), 5);
    });

    test('insert newlines', () {
      final doc = CodeDocument('hello');
      doc.insert(5, '\nworld');
      expect(doc.text, 'hello\nworld');
      expect(doc.offsetToLineColumn(6), (1, 0));
      expect(doc.offsetToLineColumn(10), (1, 4));
    });
  });

  // ---------------------------------------------------------------------------

  group('CodeDocument – deletion', () {
    test('delete from empty does nothing', () {
      final doc = CodeDocument('');
      expect(() => doc.delete(offset: 0, count: 1), throwsRangeError);
      expect(doc.text, '');
    });

    test('delete inside single piece', () {
      final doc = CodeDocument('abcdef');
      doc.delete(offset: 2, count: 3); // remove cde
      expect(doc.text, 'abf');
      expect(doc.length, 3);
      expect(doc.offsetToLineColumn(2), (0, 2));
    });

    test('delete across piece boundaries', () {
      final doc = CodeDocument('abc');
      doc.insert(3, 'XYZ');
      doc.delete(offset: 1, count: 4); // remove 'bcXY'
      expect(doc.text, 'aZ');
      expect(doc.length, 2);
    });

    test('delete newline boundary', () {
      final doc = CodeDocument('hello\nworld');
      doc.delete(offset: 5, count: 1); // remove the '\n'
      expect(doc.text, 'helloworld');
      expect(doc.offsetToLineColumn(7), (0, 7)); // now single line
    });

    test('delete entire document', () {
      final doc = CodeDocument('abc\ndef');
      doc.delete(offset: 0, count: doc.length);
      expect(doc.text, '');
      expect(doc.offsetToLineColumn(0), (0, 0));
    });
  });

  // ---------------------------------------------------------------------------

  group('CodeDocument – complex mixed edits', () {
    test('insert → delete → insert produces correct final text', () {
      final doc = CodeDocument('hello\nworld');

      doc.insert(5, '!'); // hello!\nworld
      doc.delete(offset: 6, count: 1); // hello!world
      doc.insert(6, '???'); // hello!???world

      expect(doc.text, 'hello!???world');
      expect(doc.offsetToLineColumn(8), (0, 8));
    });

    test('multiple newlines inserted and deleted', () {
      final doc = CodeDocument('a');
      doc.insert(1, '\nb\nc\nd'); // a\nb\nc\nd
      doc.delete(offset: 2, count: 4); // remove 'b\nc\n'
      expect(doc.text, 'a\nd');
      expect(doc.offsetToLineColumn(2), (1, 0));
      expect(doc.offsetToLineColumn(3), (1, 1));
    });
  });

  // ---------------------------------------------------------------------------

  group('CodeDocument – mapping correctness', () {
    test('offsetToLineColumn and lineColumnToOffset round trip', () {
      final doc = CodeDocument('abc\ndef\n12345');

      for (int offset = 0; offset < doc.length; offset++) {
        final (line, col) = doc.offsetToLineColumn(offset);
        final roundTrip = doc.lineColumnToOffset(line, col);
        expect(roundTrip, offset);
      }
    });

    test('mapping at line boundaries', () {
      final doc = CodeDocument('a\nbb\nccc');

      expect(doc.offsetToLineColumn(0), (0, 0));
      expect(doc.offsetToLineColumn(1), (0, 1));
      expect(doc.offsetToLineColumn(2), (1, 0));
      expect(doc.offsetToLineColumn(4), (1, 2));
      expect(doc.offsetToLineColumn(5), (2, 0));
    });
  });
}
