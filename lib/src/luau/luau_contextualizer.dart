import 'package:kalua/src/code/contextualizer.dart';

import '../code/lexing.dart';

/// Contextualizer for the Luau language, adds semantic meaning on top of lexer tokens.
class LuauContextualizer implements Contextualizer {
  @override
  List<SemanticToken> contextualize(String code, List<LexerToken> lexerTokens) {
    final semanticTokens = <SemanticToken>[];
    final genericStack = <LexerToken>[]; // track open < generic braces

    for (int i = 0; i < lexerTokens.length; i++) {
      final token = lexerTokens[i];
      final text = code.substring(token.start, token.end);

      switch (token.kind) {
        case SyntaxKind.string:
          semanticTokens.add(SemanticToken.standard(token.start, token.end, SemanticKind.string));
          break;

        case SyntaxKind.number:
          semanticTokens.add(SemanticToken.standard(token.start, token.end, SemanticKind.number));
          break;

        case SyntaxKind.identifier:
          // Function declaration
          if (i > 0 &&
              lexerTokens[i - 1].kind == SyntaxKind.keyword &&
              code.substring(lexerTokens[i - 1].start, lexerTokens[i - 1].end) == 'function') {
            semanticTokens.add(SemanticToken.standard(token.start, token.end, SemanticKind.functionName));
          }
          // Type annotation after colon
          else if (i > 0 &&
              lexerTokens[i - 1].kind == SyntaxKind.punctuation &&
              code.substring(lexerTokens[i - 1].start, lexerTokens[i - 1].end) == ':') {
            semanticTokens.add(SemanticToken.standard(token.start, token.end, SemanticKind.typeName));
          }
          // Inside generic angle brackets
          else if (genericStack.isNotEmpty) {
            semanticTokens.add(SemanticToken.standard(token.start, token.end, SemanticKind.typeName));
          }
          // Regular identifier
          else {
            semanticTokens.add(SemanticToken.standard(token.start, token.end, SemanticKind.identifier));
          }
          break;

        case SyntaxKind.keyword:
          final textLower = text.toLowerCase();
          if ([
            'if',
            'then',
            'else',
            'elseif',
            'for',
            'while',
            'repeat',
            'until',
            'return',
            'break',
            'continue',
            'end',
          ].contains(textLower)) {
            semanticTokens.add(SemanticToken.standard(token.start, token.end, SemanticKind.controlFlow));
          } else if (['and', 'or', 'not'].contains(textLower)) {
            semanticTokens.add(SemanticToken.standard(token.start, token.end, SemanticKind.logical));
          } else if (['true', 'false'].contains(textLower)) {
            semanticTokens.add(SemanticToken.standard(token.start, token.end, SemanticKind.boolean));
          } else {
            semanticTokens.add(SemanticToken.standard(token.start, token.end, SemanticKind.keyword));
          }
          break;

        case SyntaxKind.comment:
          semanticTokens.add(SemanticToken.standard(token.start, token.end, SemanticKind.comment));
          break;

        case SyntaxKind.operatorToken:
          semanticTokens.add(_semanticizeOperator(token, text));
          break;

        case SyntaxKind.punctuation:
          final semToken = _semanticizePunctuation(token, text, lexerTokens, i);
          semanticTokens.add(semToken);

          // Track generic brace context
          if (semToken.standardKind == SemanticKind.genericBrace) {
            if (text == '<') {
              genericStack.add(token);
            } else if (text == '>') {
              if (genericStack.isNotEmpty) genericStack.removeLast();
            }
          }
          break;

        case SyntaxKind.whitespace:
          semanticTokens.add(SemanticToken.standard(token.start, token.end, SemanticKind.whitespace));
          break;

        default:
          semanticTokens.add(SemanticToken.standard(token.start, token.end, SemanticKind.unknown));
          break;
      }
    }

    return semanticTokens;
  }

  SemanticToken _semanticizeOperator(LexerToken token, String text) {
    switch (text) {
      case "+":
      case "-":
      case "*":
      case "/":
      case "%":
      case "**":
        return SemanticToken.standard(token.start, token.end, SemanticKind.arithmetic);

      case "==":
      case "~=":
      case "<":
      case ">":
      case "<=":
      case ">=":
        return SemanticToken.standard(token.start, token.end, SemanticKind.comparison);

      case "and":
      case "or":
      case "not":
        return SemanticToken.standard(token.start, token.end, SemanticKind.logical);

      case "&":
      case "|":
      case "^":
      case "~":
      case "<<":
      case ">>":
        return SemanticToken.standard(token.start, token.end, SemanticKind.bitwise);

      case "++":
      case "--":
        return SemanticToken.standard(token.start, token.end, SemanticKind.increment);

      case "?":
      case ":":
        return SemanticToken.standard(token.start, token.end, SemanticKind.ternary);

      case "=":
        return SemanticToken.standard(token.start, token.end, SemanticKind.assignment);

      default:
        return SemanticToken.standard(token.start, token.end, SemanticKind.operator);
    }
  }

  SemanticToken _semanticizePunctuation(LexerToken token, String text, List<LexerToken> tokens, int index) {
    switch (text) {
      case ";":
        return SemanticToken.standard(token.start, token.end, SemanticKind.semicolon);
      case ",":
        return SemanticToken.standard(token.start, token.end, SemanticKind.comma);
      case ":":
        return SemanticToken.standard(token.start, token.end, SemanticKind.colon);
      case ".":
        return SemanticToken.standard(token.start, token.end, SemanticKind.punctuation);
      case "(":
      case ")":
      case "{":
      case "}":
      case "[":
      case "]":
        return SemanticToken.standard(token.start, token.end, SemanticKind.brackets);
      case "<":
      case ">":
        if (_isGenericBraceContext(tokens, index)) {
          return SemanticToken.standard(token.start, token.end, SemanticKind.genericBrace);
        } else {
          return SemanticToken.standard(token.start, token.end, SemanticKind.comparison);
        }
      default:
        return SemanticToken.standard(token.start, token.end, SemanticKind.punctuation);
    }
  }

  /// Heuristic: treat < or > as generic braces if adjacent to identifiers
  bool _isGenericBraceContext(List<LexerToken> tokens, int index) {
    final prev = index > 0 ? tokens[index - 1] : null;
    final next = index + 1 < tokens.length ? tokens[index + 1] : null;

    final prevIsIdentifier = prev != null && prev.kind == SyntaxKind.identifier;
    final nextIsIdentifier = next != null && next.kind == SyntaxKind.identifier;

    return prevIsIdentifier || nextIsIdentifier;
  }
}
