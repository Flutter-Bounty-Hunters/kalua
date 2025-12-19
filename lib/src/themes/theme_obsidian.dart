import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kalua/src/editor/editor_theme.dart';
import 'package:kalua/src/luau/themes/luau_theme.dart';
import 'package:kalua/src/themes/theme.dart';

const obsidianKaluaTheme = KaluaTheme(
  brightness: Brightness.dark,
  editorTheme: EditorTheme(
    paneColor: Color(0xFF222222),
    paneDividerColor: Color(0xFF111111),
    background: Color(0xFF1E1E1E),
    indentLineColor: Color(0xFF222222),
    foreground: Color(0xFFD4D4D4),
    caret: Color(0xFFAEAFAD),
    selection: Color(0xFF264F78),
    inactiveSelection: Color(0xFF3A3D41),
    lineHighlight: Color(0xFF2A2D2E),
    gutterBackground: Color(0xFF1E1E1E),
    gutterBorder: Color(0xFF2E2E2E),
    gutterForeground: Color(0xFF858585),
    bracketHighlight: Color(0xFF515C6A),
    invisibleCharacters: Color(0xFF404040),
  ),
  luauTheme: LuauTheme(
    baseTextStyle: TextStyle(color: Color(0xFFD4D4D4)),

    // ─────────────────────────────────────────────
    // Core syntax
    // ─────────────────────────────────────────────
    keyword: TextStyle(color: Color(0xFFC586C0), fontWeight: FontWeight.bold), // local, function
    controlFlow: TextStyle(color: Color(0xFFC586C0)), // if, else, end
    identifier: TextStyle(color: Color(0xFFD4D4D4)),
    functionName: TextStyle(color: Color(0xFF569CD6)),
    typeName: TextStyle(color: Color(0xFF4EC9B0)),

    string: TextStyle(color: Color(0xFFCE9178)),
    number: TextStyle(color: Color(0xFFB5CEA8)),
    boolean: TextStyle(color: Color(0xFF569CD6)),

    comment: TextStyle(color: Color(0xFF6A9955)),
    documentationComment: TextStyle(color: Color(0xFF608B4E), fontStyle: FontStyle.italic),

    // ─────────────────────────────────────────────
    // Operators & punctuation
    // ─────────────────────────────────────────────
    operator: TextStyle(color: Color(0xFFD4D4D4)),
    arithmetic: TextStyle(color: Color(0xFFD4D4D4)),
    comparison: TextStyle(color: Color(0xFFD4D4D4)),
    logical: TextStyle(color: Color(0xFFC586C0)),
    bitwise: TextStyle(color: Color(0xFFD4D4D4)),
    assignment: TextStyle(color: Color(0xFFD4D4D4)),
    increment: TextStyle(color: Color(0xFFD4D4D4)),
    ternary: TextStyle(color: Color(0xFFD4D4D4)),

    punctuation: TextStyle(color: Color(0xFFD4D4D4)),
    comma: TextStyle(color: Color(0xFFD4D4D4)),
    colon: TextStyle(color: Color(0xFFD4D4D4)),
    semicolon: TextStyle(color: Color(0xFFD4D4D4)),
    brackets: TextStyle(color: Color(0xFFD4D4D4)),
    genericBrace: TextStyle(color: Color(0xFF808080)),

    // ─────────────────────────────────────────────
    // Misc
    // ─────────────────────────────────────────────
    whitespace: TextStyle(color: Color(0x00000000)), // invisible
    unknown: TextStyle(color: Color(0xFFFF0000)), // bright red to expose bugs
  ),
);
