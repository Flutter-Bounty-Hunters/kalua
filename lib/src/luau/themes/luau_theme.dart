import 'package:flutter/material.dart';

import 'package:kalua/src/code/contextualizer.dart';

/// Configurable color theme for Luau syntax highlighting and editor UI.
class LuauTheme {
  const LuauTheme({
    required this.baseTextColor,

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

  final Color baseTextColor;

  // ─────────────────────────────────────────────
  // Core syntax
  // ─────────────────────────────────────────────

  final Color keyword;
  final Color controlFlow;
  final Color identifier;
  final Color functionName;
  final Color typeName;

  final Color string;
  final Color number;
  final Color boolean;

  final Color comment;
  final Color documentationComment;

  // ─────────────────────────────────────────────
  // Operators & punctuation
  // ─────────────────────────────────────────────

  final Color operator;
  final Color arithmetic;
  final Color comparison;
  final Color logical;
  final Color bitwise;
  final Color assignment;
  final Color increment;
  final Color ternary;

  final Color punctuation;
  final Color comma;
  final Color colon;
  final Color semicolon;
  final Color brackets;
  final Color genericBrace;

  // ─────────────────────────────────────────────
  // Misc / fallback
  // ─────────────────────────────────────────────

  final Color whitespace;
  final Color unknown;

  Color colorForSemanticKind(SemanticKind kind) {
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
}
