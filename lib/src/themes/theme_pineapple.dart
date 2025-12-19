import 'dart:ui' hide TextStyle;

import 'package:flutter/material.dart' show TextStyle;
import 'package:kalua/src/editor/editor_theme.dart';
import 'package:kalua/src/luau/themes/luau_theme.dart';
import 'package:kalua/src/themes/theme.dart';

const pineappleTheme = KaluaTheme(
  brightness: Brightness.dark,
  editorTheme: EditorTheme(
    paneColor: Color(0xFF222222),
    paneDividerColor: Color(0xFF111111),
    indentLineColor: Color(0xFF2A3F44),

    // ─────────────────────────────────────────────
    // Editor / UI
    // ─────────────────────────────────────────────
    background: Color(0xFF1B2A2F), // deep ocean night
    foreground: Color(0xFFECE7D5), // warm sand text
    caret: Color(0xFFFFE066), // pineapple yellow

    selection: Color(0xFF2F6F7A), // ocean teal
    inactiveSelection: Color(0xFF2A3F44),

    lineHighlight: Color(0xFF22383E),

    gutterBackground: Color(0xFF18262B),
    gutterBorder: Color(0xFF2E4A50),
    gutterForeground: Color(0xFF6FAFB7),

    bracketHighlight: Color(0xFFFFE066), // pineapple accent
    invisibleCharacters: Color(0xFF4F7D85),
  ),

  luauTheme: LuauTheme(
    baseTextStyle: TextStyle(color: Color(0xFFECE7D5)),

    // ─────────────────────────────────────────────
    // Core syntax
    // ─────────────────────────────────────────────
    keyword: TextStyle(color: Color(0xFFFFC857), fontWeight: FontWeight.bold), // pineapple gold
    controlFlow: TextStyle(color: Color(0xFFFFA94D)), // sunset orange
    identifier: TextStyle(color: Color(0xFFECE7D5)), // sand
    functionName: TextStyle(color: Color(0xFF7CD992)), // palm green
    typeName: TextStyle(color: Color(0xFF5ED3E8)), // tropical sky blue

    string: TextStyle(color: Color(0xFFFF8FA3)), // hibiscus pink
    number: TextStyle(color: Color(0xFFFFE066)), // pineapple yellow
    boolean: TextStyle(color: Color(0xFFFFE066)),

    comment: TextStyle(color: Color(0xFF7FA9A3)), // weathered driftwood
    documentationComment: TextStyle(color: Color(0xFF8FC7BF), fontStyle: FontStyle.italic),

    // ─────────────────────────────────────────────
    // Operators & punctuation
    // ─────────────────────────────────────────────
    operator: TextStyle(color: Color(0xFFFFB703)), // ripe pineapple
    arithmetic: TextStyle(color: Color(0xFFFFB703)),
    comparison: TextStyle(color: Color(0xFF5ED3E8)), // ocean contrast
    logical: TextStyle(color: Color(0xFFFFA94D)), // sunset logic
    bitwise: TextStyle(color: Color(0xFF6FA8DC)), // deep water blue

    assignment: TextStyle(color: Color(0xFFFFE066)), // emphasized assignment
    increment: TextStyle(color: Color(0xFFFFB703)),
    ternary: TextStyle(color: Color(0xFFFFA94D)),

    punctuation: TextStyle(color: Color(0xFFD6D1B8)), // light sand
    comma: TextStyle(color: Color(0xFFD6D1B8)),
    colon: TextStyle(color: Color(0xFFD6D1B8)),
    semicolon: TextStyle(color: Color(0xFFD6D1B8)),

    brackets: TextStyle(color: Color(0xFF7CD992)), // palm leaf
    genericBrace: TextStyle(color: Color(0xFF5ED3E8)), // sky blue generics
    // ─────────────────────────────────────────────
    // Misc / fallback
    // ─────────────────────────────────────────────
    whitespace: TextStyle(color: Color(0xFF3E6C73)),
    unknown: TextStyle(color: Color(0xFFECE7D5)),
  ),
);
