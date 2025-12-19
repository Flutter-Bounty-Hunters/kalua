import 'dart:ui' hide TextStyle;

import 'package:flutter/material.dart' show TextStyle;
import 'package:kalua/src/editor/editor_theme.dart';
import 'package:kalua/src/luau/themes/luau_theme.dart';
import 'package:kalua/src/themes/theme.dart';

const githubLightKaluaTheme = KaluaTheme(
  brightness: Brightness.light,
  editorTheme: EditorTheme(
    paneColor: Color(0xFFEEEEEE),
    paneDividerColor: Color(0xFFDDDDDD),
    background: Color(0xFFFFFFFF),
    indentLineColor: Color(0xFFDDDDDD),
    foreground: Color(0xFF24292E),
    caret: Color(0xFF24292E),

    selection: Color(0xFFBFDFFF),
    inactiveSelection: Color(0xFFEAECEF),

    lineHighlight: Color(0xFFF6F8FA),

    gutterBackground: Color(0xFFF6F8FA),
    gutterBorder: Color(0xFFE1E4E8),
    gutterForeground: Color(0xFF6A737D),

    bracketHighlight: Color(0xFFBFDFFF),
    invisibleCharacters: Color(0xFFCED4DA),
  ),

  luauTheme: LuauTheme(
    baseTextStyle: TextStyle(color: Color(0xFF24292E)),

    // ─────────────────────────────────────────────
    // Core syntax
    // ─────────────────────────────────────────────
    keyword: TextStyle(color: Color(0xFFD73A49), fontWeight: FontWeight.bold), // red
    controlFlow: TextStyle(color: Color(0xFFD73A49)), // red
    identifier: TextStyle(color: Color(0xFF24292E)), // near-black
    functionName: TextStyle(color: Color(0xFF6F42C1)), // purple
    typeName: TextStyle(color: Color(0xFF005CC5)), // blue

    string: TextStyle(color: Color(0xFF032F62)), // dark blue
    number: TextStyle(color: Color(0xFF005CC5)), // blue
    boolean: TextStyle(color: Color(0xFF005CC5)), // blue

    comment: TextStyle(color: Color(0xFF6A737D)), // gray
    documentationComment: TextStyle(color: Color(0xFF6A737D), fontStyle: FontStyle.italic),

    // ─────────────────────────────────────────────
    // Operators & punctuation
    // ─────────────────────────────────────────────
    operator: TextStyle(color: Color(0xFFD73A49)),
    arithmetic: TextStyle(color: Color(0xFFD73A49)),
    comparison: TextStyle(color: Color(0xFFD73A49)),
    logical: TextStyle(color: Color(0xFFD73A49)),
    bitwise: TextStyle(color: Color(0xFFD73A49)),

    assignment: TextStyle(color: Color(0xFF005CC5)), // slightly emphasized
    increment: TextStyle(color: Color(0xFFD73A49)),
    ternary: TextStyle(color: Color(0xFFD73A49)),

    punctuation: TextStyle(color: Color(0xFF24292E)),
    comma: TextStyle(color: Color(0xFF24292E)),
    colon: TextStyle(color: Color(0xFF24292E)),
    semicolon: TextStyle(color: Color(0xFF24292E)),

    brackets: TextStyle(color: Color(0xFF24292E)),
    genericBrace: TextStyle(color: Color(0xFF005CC5)), // type-related emphasis
    // ─────────────────────────────────────────────
    // Misc / fallback
    // ─────────────────────────────────────────────
    whitespace: TextStyle(color: Color(0xFFCED4DA)),
    unknown: TextStyle(color: Color(0xFF24292E)),
  ),
);
