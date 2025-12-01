import 'dart:ui';

import '../code/code_document.dart';

class LuauTokenProvider implements TokenProvider {
  @override
  List<TokenSpan> tokenize(String fullText) {
    final tokens = <TokenSpan>[];
    int i = 0;
    final length = fullText.length;

    while (i < length) {
      final code = fullText.codeUnitAt(i);

      // Skip whitespace
      if (_isWhitespace(code)) {
        i++;
        continue;
      }

      // Comments
      if (code == 0x2D /* '-' */ && i + 1 < length && fullText.codeUnitAt(i + 1) == 0x2D) {
        final start = i;
        i += 2;
        // Multi-line comment
        if (i + 1 < length && fullText[i] == '[' && fullText[i + 1] == '[') {
          i += 2;
          while (i + 1 < length && !(fullText[i] == ']' && fullText[i + 1] == ']')) {
            i++;
          }
          i += 2; // skip ]]
        } else {
          // Single-line comment
          while (i < length && fullText[i] != '\n') i++;
        }
        tokens.add(TokenSpan(start, i, SyntaxKind.comment));
        continue;
      }

      // Strings
      if (code == 0x22 /* " */ || code == 0x27 /* ' */ ) {
        final start = i;
        final quote = fullText[i];
        i++;
        while (i < length) {
          if (fullText[i] == '\\') {
            i += 2; // skip escaped char
          } else if (fullText[i] == quote) {
            i++;
            break;
          } else {
            i++;
          }
        }
        tokens.add(TokenSpan(start, i, SyntaxKind.string));
        continue;
      }

      // Numbers
      if (_isDigit(code)) {
        final start = i;
        i++;
        while (i < length && (_isDigit(fullText.codeUnitAt(i)) || fullText[i] == '.')) i++;
        tokens.add(TokenSpan(start, i, SyntaxKind.number));
        continue;
      }

      // Identifiers / keywords
      if (_isIdentifierStart(code)) {
        final start = i;
        i++;
        while (i < length && _isIdentifierChar(fullText.codeUnitAt(i))) i++;
        final text = fullText.substring(start, i);
        final kind = _isKeyword(text) ? SyntaxKind.keyword : SyntaxKind.identifier;
        tokens.add(TokenSpan(start, i, kind));
        continue;
      }

      // Multi-character operators first
      if (i + 1 < fullText.length) {
        final twoChar = fullText.substring(i, i + 2);
        if (twoChar == ".." || twoChar == "==" || twoChar == "~=" || twoChar == "<=" || twoChar == ">=") {
          tokens.add(TokenSpan(i, i + 2, SyntaxKind.operatorToken));
          i += 2;
          continue;
        }
      }

      // Single-character operators
      if ("+-*/%^&|~<>#=".contains(fullText[i])) {
        tokens.add(TokenSpan(i, i + 1, SyntaxKind.operatorToken));
        i++;
        continue;
      }

      // Punctuation
      if (";,:(){}[].".contains(fullText[i])) {
        tokens.add(TokenSpan(i, i + 1, SyntaxKind.punctuation));
        i++;
        continue;
      }

      // Unknown
      tokens.add(TokenSpan(i, i + 1, SyntaxKind.unknown));
      i++;
    }

    return tokens;
  }

  @override
  List<TokenSpan>? tokenizePartial({required String fullText, required TextRange range}) {
    // For now, just tokenize the requested range fully.
    final fullTokens = tokenize(fullText);

    // Filter tokens that overlap the range
    return fullTokens.where((t) => t.end > range.start && t.start < range.end).toList();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  bool _isWhitespace(int code) {
    return code == 0x20 || code == 0x09 || code == 0x0A || code == 0x0D;
  }

  bool _isDigit(int code) => code >= 0x30 && code <= 0x39; // 0-9

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
