import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:kalua/kalua.dart';

void main() {
  late LuauTokenProvider tokenizer;

  setUp(() {
    tokenizer = LuauTokenProvider();
  });

  group('LuauTokenProvider full tokenization', () {
    test('identifiers and keywords', () {
      const code = 'local x = 10 if x > 5 then return x end';
      final tokens = tokenizer.tokenize(code);

      final expectedKinds = [
        SyntaxKind.keyword, // local
        SyntaxKind.identifier, // x
        SyntaxKind.operatorToken, // =
        SyntaxKind.number, // 10
        SyntaxKind.keyword, // if
        SyntaxKind.identifier, // x
        SyntaxKind.operatorToken, // >
        SyntaxKind.number, // 5
        SyntaxKind.keyword, // then
        SyntaxKind.keyword, // return
        SyntaxKind.identifier, // x
        SyntaxKind.keyword, // end
      ];

      expect(tokens.map((t) => t.kind).toList(), expectedKinds);
    });

    test('strings', () {
      const code = r'''local s = "hello" local t = 'world' ''';
      final tokens = tokenizer.tokenize(code);

      expect(tokens.map((t) => t.kind), containsAll([SyntaxKind.string, SyntaxKind.string]));
      expect(tokens.map((t) => code.substring(t.start, t.end)), containsAll(['"hello"', "'world'"]));
    });

    test('numbers', () {
      const code = 'x = 42 y = 3.14 z = 0.5';
      final tokens = tokenizer.tokenize(code);

      expect(tokens.where((t) => t.kind == SyntaxKind.number).length, 3);
      expect(tokens.map((t) => code.substring(t.start, t.end)), containsAll(['42', '3.14', '0.5']));
    });

    test('operators and punctuation', () {
      // Note: Not all of these are operators - we expect the tokenizer to ignore
      // non-operator tokens, but find the operator tokens.
      //
      // Operators: + - * / % ^ = < > == <= >= # & | ~
      const code = '[ ] ( ) { } ; , + - * / % ^ = < > == <= >= # & | ~ : .';
      final tokens = tokenizer.tokenize(code);

      expect(tokens.where((t) => t.kind == SyntaxKind.operatorToken).length, 16);
    });

    test('comments', () {
      const code = '-- single line\n--[[ multi-line ]]';
      final tokens = tokenizer.tokenize(code);

      expect(tokens.where((t) => t.kind == SyntaxKind.comment).length, 2);
    });

    test('mixed code', () {
      const code = r'''
local x = 5 -- comment
if x > 0 then
    print("Hello")
end
''';
      final tokens = tokenizer.tokenize(code);

      // Ensure at least one token of each expected kind
      expect(
        tokens.map((t) => t.kind),
        containsAll([
          SyntaxKind.keyword,
          SyntaxKind.identifier,
          SyntaxKind.number,
          SyntaxKind.comment,
          SyntaxKind.string,
        ]),
      );
    });
  });

  group('LuauTokenProvider partial tokenization', () {
    const code = r'''
local x = 10
local y = x + 5
''';

    test('tokenize a single line range', () {
      final range = TextRange(start: 0, end: 12); // "local x = 10\n"
      final tokens = tokenizer.tokenizePartial(fullText: code, range: range)!;

      // Should include only tokens overlapping first line
      expect(tokens.map((t) => code.substring(t.start, t.end)).join(' '), contains('local x = 10'));
      expect(tokens.any((t) => t.kind == SyntaxKind.keyword), isTrue);
      expect(tokens.any((t) => t.kind == SyntaxKind.number), isTrue);
    });

    test('tokenize range covering part of a line', () {
      final range = TextRange(start: 6, end: 12);
      final tokens = tokenizer.tokenizePartial(fullText: code, range: range)!;

      expect(tokens[0].kind, SyntaxKind.identifier);
      expect(tokens[1].kind, SyntaxKind.operatorToken);
      expect(tokens[2].kind, SyntaxKind.number);
    });

    test('tokenize multiple lines', () {
      final range = TextRange(start: 0, end: code.length);
      final tokens = tokenizer.tokenizePartial(fullText: code, range: range)!;

      expect(tokens.length, tokenizer.tokenize(code).length);
    });
  });
}
