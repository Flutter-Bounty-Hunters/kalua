import 'package:flutter_test/flutter_test.dart';
import 'package:kalua/kalua.dart';

void main() {
  group("Syntax Highlighter >", () {
    group("comments >", () {
      test("single line comments", () {
        final multiplePerLineComments = '''-----------------------
-- Types and Type Aliases
-----------------------''';

        final code = CodeDocument(multiplePerLineComments);

        expect(code.tokens, [
          LexerToken(0, 23, SyntaxKind.comment),
          LexerToken(24, 49, SyntaxKind.comment),
          LexerToken(50, 73, SyntaxKind.comment),
        ]);
      });

      test("multi-line comments", () {
        final multiLineComment = '''--[[
    Full Luau Syntax Showcase
    Demonstrates variables, functions, classes, types, metatables, tables,
    loops, control flow, operators, coroutines, modules, and more.
]]''';

        final code = CodeDocument(multiLineComment);

        expect(code.tokens, [LexerToken(0, multiLineComment.length, SyntaxKind.comment)]);
      });
    });

    group("declarations >", () {
      group("local variables >", () {
        test("integer assignment", () {
          expect(CodeDocument("local x = 1").tokens, [
            LexerToken(0, 5, SyntaxKind.keyword),
            LexerToken(6, 7, SyntaxKind.identifier),
            LexerToken(8, 9, SyntaxKind.operatorToken),
            LexerToken(10, 11, SyntaxKind.number),
          ]);
        });
      });

      group("type definitions >", () {
        test("union type assignment", () {
          expect(CodeDocument("type NumberOrString = number | string").tokens, [
            LexerToken(0, 4, SyntaxKind.identifier),
            LexerToken(5, 19, SyntaxKind.identifier),
            LexerToken(20, 21, SyntaxKind.operatorToken),
            LexerToken(22, 28, SyntaxKind.identifier),
            LexerToken(29, 30, SyntaxKind.operatorToken),
            LexerToken(31, 37, SyntaxKind.identifier),
          ]);
        });

        test("table with explicit keys", () {
          expect(CodeDocument("type Vec2 = { x: number, y: number }").tokens, [
            LexerToken(0, 4, SyntaxKind.identifier),
            LexerToken(5, 9, SyntaxKind.identifier),
            LexerToken(10, 11, SyntaxKind.operatorToken),
            LexerToken(12, 13, SyntaxKind.punctuation),
            LexerToken(14, 15, SyntaxKind.identifier),
            LexerToken(15, 16, SyntaxKind.punctuation),
            LexerToken(17, 23, SyntaxKind.identifier),
            LexerToken(23, 24, SyntaxKind.punctuation),
            LexerToken(25, 26, SyntaxKind.identifier),
            LexerToken(26, 27, SyntaxKind.punctuation),
            LexerToken(28, 34, SyntaxKind.identifier),
            LexerToken(35, 36, SyntaxKind.punctuation),
          ]);
        });

        test("table with array keys", () {
          expect(CodeDocument("type StringMap<T> = { [string]: T }").tokens, [
            LexerToken(0, 4, SyntaxKind.identifier),
            LexerToken(5, 14, SyntaxKind.identifier),
            LexerToken(14, 15, SyntaxKind.operatorToken),
            LexerToken(15, 16, SyntaxKind.identifier),
            LexerToken(16, 17, SyntaxKind.operatorToken),
            LexerToken(18, 19, SyntaxKind.operatorToken),
            LexerToken(20, 21, SyntaxKind.punctuation),
            LexerToken(22, 23, SyntaxKind.punctuation),
            LexerToken(23, 29, SyntaxKind.identifier),
            LexerToken(29, 30, SyntaxKind.punctuation),
            LexerToken(30, 31, SyntaxKind.punctuation),
            LexerToken(32, 33, SyntaxKind.identifier),
            LexerToken(34, 35, SyntaxKind.punctuation),
          ]);
        });
      });
    });
  });
}
