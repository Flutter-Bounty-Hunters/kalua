import 'dart:ui';

import 'package:kalua/src/code/lexing.dart';

/// Lexer for the Luau language.
///
/// Lexing (lexical analysis) breaks a plain-text Luau script into tokens, based on the
/// language syntax. See [SyntaxKind] for the set of available Luau token types.
///
/// Users might choose to do a semantic pass after doing a lexical pass. For example,
/// from a lexical perspective, a greater than operator ("a > b") and a generic brace
/// ("<Foo>") are the same thing. However, from a semantic perspective, they are different.
/// To obtain semantic information, run a Luau parser after lexing the script.
class LuauLexer implements Lexer {
  @override
  List<LexerToken> tokenize(String fullText) {
    final tokens = <LexerToken>[];
    int i = 0;
    final length = fullText.length;

    while (i < length) {
      final code = fullText.codeUnitAt(i);

      // Whitespace
      if (_isWhitespace(code)) {
        while (i < length && _isWhitespace(fullText.codeUnitAt(i))) {
          i += 1;
        }
        continue;
      }

      // Comments
      if (code == 0x2D /* '-' */ && i + 1 < length && fullText.codeUnitAt(i + 1) == 0x2D) {
        final start = i;
        i += 2;

        // Multi-line comment
        if (i + 1 < length &&
            fullText.codeUnitAt(i) == 0x5B /* '[' */ &&
            fullText.codeUnitAt(i + 1) == 0x5B /* '[' */ ) {
          i += 2;
          while (i + 1 < length &&
              !(fullText.codeUnitAt(i) == 0x5D /* ']' */ && fullText.codeUnitAt(i + 1) == 0x5D /* ']' */ )) {
            i += 1;
          }
          // Include the closing ]]
          if (i + 1 < length) i += 2;
        } else {
          // Single-line comment
          while (i < length && fullText.codeUnitAt(i) != 0x0A) {
            i += 1;
          }
        }

        tokens.add(LexerToken(start, i, SyntaxKind.comment));
        continue;
      }

      // Strings
      if (code == 0x22 /* " */ || code == 0x27 /* ' */ ) {
        final start = i;
        final quote = fullText[i];
        i++;
        while (i < length) {
          if (fullText[i] == '\\') {
            i += 2;
          } else if (fullText[i] == quote) {
            i++;
            break;
          } else {
            i++;
          }
        }
        tokens.add(LexerToken(start, i, SyntaxKind.string));
        continue;
      }

      // Numbers
      if (_isDigit(code)) {
        final start = i;
        i++;
        while (i < length && (_isDigit(fullText.codeUnitAt(i)) || fullText[i] == '.')) {
          i++;
        }
        tokens.add(LexerToken(start, i, SyntaxKind.number));
        continue;
      }

      // Identifiers / keywords
      if (_isIdentifierStart(code)) {
        final start = i;
        i++;
        while (i < length && _isIdentifierChar(fullText.codeUnitAt(i))) {
          i++;
        }
        final text = fullText.substring(start, i);
        final kind = _isKeyword(text) ? SyntaxKind.keyword : SyntaxKind.identifier;
        tokens.add(LexerToken(start, i, kind));
        continue;
      }

      // Multi-character operators
      if (i + 1 < length) {
        final twoChar = fullText.substring(i, i + 2);
        if (twoChar == ".." || twoChar == "==" || twoChar == "~=" || twoChar == "<=" || twoChar == ">=") {
          tokens.add(LexerToken(i, i + 2, SyntaxKind.operatorToken));
          i += 2;
          continue;
        }
      }

      // Single-character operators (minus < >)
      if ("+-*/%^&|~#=<>".contains(fullText[i])) {
        tokens.add(LexerToken(i, i + 1, SyntaxKind.operatorToken));
        i++;
        continue;
      }

      // Punctuation
      if (";,:(){}[].".contains(fullText[i])) {
        tokens.add(LexerToken(i, i + 1, SyntaxKind.punctuation));
        i++;
        continue;
      }

      // Unknown
      tokens.add(LexerToken(i, i + 1, SyntaxKind.unknown));
      i++;
    }

    return tokens;
  }

  @override
  List<LexerToken>? tokenizePartial({required String fullText, required TextRange range}) {
    // Expand the range to include 1 char before and after to catch adjacent tokens
    final start = (range.start - 1).clamp(0, fullText.length);
    final end = (range.end + 1).clamp(0, fullText.length);

    final fullTokens = tokenize(fullText);

    // Return all tokens that overlap the expanded range
    return fullTokens.where((t) => t.end > start && t.start < end).toList();
  }

  // ----------------- helpers -----------------
  bool _isWhitespace(int code) => code == 0x20 || code == 0x09 || code == 0x0A || code == 0x0D;
  bool _isDigit(int code) => code >= 0x30 && code <= 0x39;
  bool _isIdentifierStart(int code) => (code >= 0x41 && code <= 0x5A) || (code >= 0x61 && code <= 0x7A) || code == 0x5F;
  bool _isIdentifierChar(int code) => _isIdentifierStart(code) || _isDigit(code);

  bool _isKeyword(String text) {
    const keywords = [
      'and',
      'break',
      'do',
      'else',
      'elseif',
      'end',
      'false',
      'for',
      'function',
      'if',
      'in',
      'local',
      'nil',
      'not',
      'or',
      'repeat',
      'return',
      'then',
      'true',
      'until',
      'while',
    ];
    return keywords.contains(text);
  }
}
