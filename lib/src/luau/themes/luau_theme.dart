import 'package:flutter/material.dart';

import 'package:kalua/src/code/contextualizer.dart';

/// Configurable color theme for Luau syntax highlighting and editor UI.
class LuauTheme {
  factory LuauTheme.fromJson(Map<String, dynamic> json) {
    return LuauTheme(
      baseTextStyle: textStyleFromJson(json['baseTextStyle']),

      keyword: textStyleFromJson(json['keyword']),
      controlFlow: textStyleFromJson(json['controlFlow']),
      identifier: textStyleFromJson(json['identifier']),
      functionName: textStyleFromJson(json['functionName']),
      typeName: textStyleFromJson(json['typeName']),
      string: textStyleFromJson(json['string']),
      number: textStyleFromJson(json['number']),
      boolean: textStyleFromJson(json['boolean']),
      comment: textStyleFromJson(json['comment']),
      documentationComment: textStyleFromJson(json['documentationComment']),

      operator: textStyleFromJson(json['operator']),
      arithmetic: textStyleFromJson(json['arithmetic']),
      comparison: textStyleFromJson(json['comparison']),
      logical: textStyleFromJson(json['logical']),
      bitwise: textStyleFromJson(json['bitwise']),
      assignment: textStyleFromJson(json['assignment']),
      increment: textStyleFromJson(json['increment']),
      ternary: textStyleFromJson(json['ternary']),
      punctuation: textStyleFromJson(json['punctuation']),
      comma: textStyleFromJson(json['comma']),
      colon: textStyleFromJson(json['colon']),
      semicolon: textStyleFromJson(json['semicolon']),
      brackets: textStyleFromJson(json['brackets']),
      genericBrace: textStyleFromJson(json['genericBrace']),

      whitespace: textStyleFromJson(json['whitespace']),
      unknown: textStyleFromJson(json['unknown']),
    );
  }

  const LuauTheme({
    required this.baseTextStyle,

    // Core syntax
    required this.keyword,
    required this.controlFlow,
    required this.identifier,
    required this.functionName,
    required this.typeName,
    required this.string,
    required this.number,
    required this.boolean,
    required this.comment,
    required this.documentationComment,

    // Operators & punctuation
    required this.operator,
    required this.arithmetic,
    required this.comparison,
    required this.logical,
    required this.bitwise,
    required this.assignment,
    required this.increment,
    required this.ternary,
    required this.punctuation,
    required this.comma,
    required this.colon,
    required this.semicolon,
    required this.brackets,
    required this.genericBrace,

    // Misc
    required this.whitespace,
    required this.unknown,
  });

  final TextStyle baseTextStyle;

  // ─────────────────────────────────────────────
  // Core syntax
  // ─────────────────────────────────────────────

  final TextStyle keyword;
  final TextStyle controlFlow;
  final TextStyle identifier;
  final TextStyle functionName;
  final TextStyle typeName;

  final TextStyle string;
  final TextStyle number;
  final TextStyle boolean;

  final TextStyle comment;
  final TextStyle documentationComment;

  // ─────────────────────────────────────────────
  // Operators & punctuation
  // ─────────────────────────────────────────────

  final TextStyle operator;
  final TextStyle arithmetic;
  final TextStyle comparison;
  final TextStyle logical;
  final TextStyle bitwise;
  final TextStyle assignment;
  final TextStyle increment;
  final TextStyle ternary;

  final TextStyle punctuation;
  final TextStyle comma;
  final TextStyle colon;
  final TextStyle semicolon;
  final TextStyle brackets;
  final TextStyle genericBrace;

  // ─────────────────────────────────────────────
  // Misc / fallback
  // ─────────────────────────────────────────────

  final TextStyle whitespace;
  final TextStyle unknown;

  TextStyle styleForSemanticKind(SemanticKind kind) {
    switch (kind) {
      case SemanticKind.keyword:
        return keyword;
      case SemanticKind.controlFlow:
        return controlFlow;
      case SemanticKind.identifier:
        return identifier;
      case SemanticKind.functionName:
        return functionName;
      case SemanticKind.typeName:
        return typeName;

      case SemanticKind.string:
        return string;
      case SemanticKind.number:
        return number;
      case SemanticKind.boolean:
        return boolean;

      case SemanticKind.comment:
        return comment;

      case SemanticKind.operator:
        return operator;
      case SemanticKind.arithmetic:
        return arithmetic;
      case SemanticKind.comparison:
        return comparison;
      case SemanticKind.logical:
        return logical;
      case SemanticKind.bitwise:
        return bitwise;
      case SemanticKind.assignment:
        return assignment;
      case SemanticKind.increment:
        return increment;
      case SemanticKind.ternary:
        return ternary;

      case SemanticKind.punctuation:
        return punctuation;
      case SemanticKind.comma:
        return comma;
      case SemanticKind.colon:
        return colon;
      case SemanticKind.semicolon:
        return semicolon;
      case SemanticKind.brackets:
        return brackets;
      case SemanticKind.genericBrace:
        return genericBrace;

      case SemanticKind.whitespace:
        return whitespace;
      case SemanticKind.unknown:
      default:
        return unknown;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'baseTextStyle': textStyleToJson(baseTextStyle),

      // Core syntax
      'keyword': textStyleToJson(keyword),
      'controlFlow': textStyleToJson(controlFlow),
      'identifier': textStyleToJson(identifier),
      'functionName': textStyleToJson(functionName),
      'typeName': textStyleToJson(typeName),
      'string': textStyleToJson(string),
      'number': textStyleToJson(number),
      'boolean': textStyleToJson(boolean),
      'comment': textStyleToJson(comment),
      'documentationComment': textStyleToJson(documentationComment),

      // Operators & punctuation
      'operator': textStyleToJson(operator),
      'arithmetic': textStyleToJson(arithmetic),
      'comparison': textStyleToJson(comparison),
      'logical': textStyleToJson(logical),
      'bitwise': textStyleToJson(bitwise),
      'assignment': textStyleToJson(assignment),
      'increment': textStyleToJson(increment),
      'ternary': textStyleToJson(ternary),
      'punctuation': textStyleToJson(punctuation),
      'comma': textStyleToJson(comma),
      'colon': textStyleToJson(colon),
      'semicolon': textStyleToJson(semicolon),
      'brackets': textStyleToJson(brackets),
      'genericBrace': textStyleToJson(genericBrace),

      // Misc
      'whitespace': textStyleToJson(whitespace),
      'unknown': textStyleToJson(unknown),
    };
  }
}

Map<String, dynamic> textStyleToJson(TextStyle style) {
  return {
    'color': style.color?.toARGB32(),
    'fontWeight': style.fontWeight?.index,
    'fontStyle': style.fontStyle?.index,
    'letterSpacing': style.letterSpacing,
    'height': style.height,
  };
}

TextStyle textStyleFromJson(Map<String, dynamic> json) {
  return TextStyle(
    color: json['color'] != null ? Color(json['color']) : null,
    fontWeight: json['fontWeight'] != null ? FontWeight.values[json['fontWeight']] : null,
    fontStyle: json['fontStyle'] != null ? FontStyle.values[json['fontStyle']] : null,
    letterSpacing: (json['letterSpacing'] as num?)?.toDouble(),
    height: (json['height'] as num?)?.toDouble(),
  );
}
