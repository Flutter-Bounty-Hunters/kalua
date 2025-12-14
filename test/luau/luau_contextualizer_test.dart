import 'package:flutter_test/flutter_test.dart';
import 'package:kalua/kalua.dart';

void main() {
  group('LuauContextualizer', () {
    late LuauContextualizer contextualizer;

    setUp(() {
      contextualizer = LuauContextualizer();
    });

    test('string and number literals', () {
      final code = '''
local s = "hello"
local n = 42
''';
      final lexerTokens = [
        LexerToken(0, 5, SyntaxKind.keyword), // local
        LexerToken(6, 7, SyntaxKind.identifier), // s
        LexerToken(8, 9, SyntaxKind.operatorToken), // =
        LexerToken(10, 17, SyntaxKind.string), // "hello"
        LexerToken(18, 23, SyntaxKind.keyword), // local
        LexerToken(24, 25, SyntaxKind.identifier), // n
        LexerToken(26, 27, SyntaxKind.operatorToken), // =
        LexerToken(28, 30, SyntaxKind.number), // 42
      ];

      final semantic = contextualizer.contextualize(code, lexerTokens);
      expect(semantic.map((t) => t.standardKind).toList(), [
        SemanticKind.keyword,
        SemanticKind.identifier,
        SemanticKind.assignment,
        SemanticKind.string,
        SemanticKind.keyword,
        SemanticKind.identifier,
        SemanticKind.assignment,
        SemanticKind.number,
      ]);
    });

    test('function declaration and call', () {
      final code = '''
local function foo(x)
    return x + 1
end

foo(3)
''';
      final lexerTokens = [
        LexerToken(0, 5, SyntaxKind.keyword), // local
        LexerToken(6, 14, SyntaxKind.keyword), // function
        LexerToken(15, 18, SyntaxKind.identifier), // foo
        LexerToken(18, 19, SyntaxKind.punctuation), // (
        LexerToken(19, 20, SyntaxKind.identifier), // x
        LexerToken(20, 21, SyntaxKind.punctuation), // )
        LexerToken(26, 32, SyntaxKind.keyword), // return
        LexerToken(33, 34, SyntaxKind.identifier), // x
        LexerToken(35, 36, SyntaxKind.operatorToken), // +
        LexerToken(37, 38, SyntaxKind.number), // 1
        LexerToken(39, 42, SyntaxKind.keyword), // end
        LexerToken(44, 47, SyntaxKind.identifier), // foo
        LexerToken(47, 48, SyntaxKind.punctuation), // (
        LexerToken(48, 49, SyntaxKind.number), // 3
        LexerToken(49, 50, SyntaxKind.punctuation), // )
      ];

      final semantic = contextualizer.contextualize(code, lexerTokens);
      expect(semantic.map((t) => t.standardKind).toList(), [
        SemanticKind.keyword,
        SemanticKind.keyword,
        SemanticKind.functionName,
        SemanticKind.brackets,
        SemanticKind.identifier,
        SemanticKind.brackets,
        SemanticKind.controlFlow,
        SemanticKind.identifier,
        SemanticKind.arithmetic,
        SemanticKind.number,
        SemanticKind.controlFlow,
        SemanticKind.identifier,
        SemanticKind.brackets,
        SemanticKind.number,
        SemanticKind.brackets,
      ]);
    });

    test('if/else and logical operators', () {
      final code = '''
if x > 10 and y < 5 then
    return true
else
    return false
end
''';
      final lexerTokens = [
        LexerToken(0, 2, SyntaxKind.keyword), // if
        LexerToken(3, 4, SyntaxKind.identifier), // x
        LexerToken(5, 6, SyntaxKind.operatorToken), // >
        LexerToken(7, 9, SyntaxKind.number), // 10
        LexerToken(10, 13, SyntaxKind.operatorToken), // and
        LexerToken(14, 15, SyntaxKind.identifier), // y
        LexerToken(16, 17, SyntaxKind.operatorToken), // <
        LexerToken(18, 19, SyntaxKind.number), // 5
        LexerToken(20, 24, SyntaxKind.keyword), // then
        LexerToken(29, 35, SyntaxKind.keyword), // return
        LexerToken(36, 40, SyntaxKind.keyword), // true
        LexerToken(41, 45, SyntaxKind.keyword), // else
        LexerToken(50, 56, SyntaxKind.keyword), // return
        LexerToken(57, 62, SyntaxKind.keyword), // false
        LexerToken(63, 66, SyntaxKind.keyword), // end
      ];

      final semantic = contextualizer.contextualize(code, lexerTokens);
      expect(semantic.map((t) => t.standardKind).toList(), [
        SemanticKind.controlFlow,
        SemanticKind.identifier,
        SemanticKind.comparison,
        SemanticKind.number,
        SemanticKind.logical,
        SemanticKind.identifier,
        SemanticKind.comparison,
        SemanticKind.number,
        SemanticKind.controlFlow,
        SemanticKind.controlFlow,
        SemanticKind.boolean,
        SemanticKind.controlFlow,
        SemanticKind.controlFlow,
        SemanticKind.boolean,
        SemanticKind.controlFlow,
      ]);
    });

    test('generic braces in type annotations', () {
      final code = '''
local t: Dictionary<string, number>
''';
      final lexerTokens = [
        LexerToken(0, 5, SyntaxKind.keyword), // local
        LexerToken(6, 7, SyntaxKind.identifier), // t
        LexerToken(7, 8, SyntaxKind.punctuation), // :
        LexerToken(9, 19, SyntaxKind.identifier), // Dictionary
        LexerToken(19, 20, SyntaxKind.punctuation), // <
        LexerToken(20, 26, SyntaxKind.identifier), // string
        LexerToken(26, 27, SyntaxKind.punctuation), // ,
        LexerToken(28, 34, SyntaxKind.identifier), // number
        LexerToken(34, 35, SyntaxKind.punctuation), // >
      ];

      final semantic = contextualizer.contextualize(code, lexerTokens);
      expect(semantic.map((t) => t.standardKind).toList(), [
        SemanticKind.keyword,
        SemanticKind.identifier,
        SemanticKind.colon,
        SemanticKind.typeName,
        SemanticKind.genericBrace,
        SemanticKind.typeName,
        SemanticKind.comma,
        SemanticKind.typeName,
        SemanticKind.genericBrace,
      ]);
    });

    test('comments', () {
      final code = '''
-- single line
--[[ multi-line ]]
''';
      final lexerTokens = [LexerToken(0, 15, SyntaxKind.comment), LexerToken(16, 32, SyntaxKind.comment)];

      final semantic = contextualizer.contextualize(code, lexerTokens);
      expect(semantic.map((t) => t.standardKind).toList(), [SemanticKind.comment, SemanticKind.comment]);
    });
  });
}
