import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kalua/src/editor/editor_theme.dart';
import 'package:kalua/src/luau/themes/luau_theme.dart';
import 'package:kalua/src/themes/theme.dart';

const obsidianKaluaTheme = KaluaTheme(
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
  luauCodeTheme: LuauTheme(
    baseTextColor: Color(0xFFD4D4D4),

    // ─────────────────────────────────────────────
    // Core syntax
    // ─────────────────────────────────────────────
    keyword: Color(0xFFC586C0), // local, function
    controlFlow: Color(0xFFC586C0), // if, else, end
    identifier: Color(0xFFD4D4D4),
    functionName: Color(0xFF569CD6),
    typeName: Color(0xFF4EC9B0),

    string: Color(0xFFCE9178),
    number: Color(0xFFB5CEA8),
    boolean: Color(0xFF569CD6),

    comment: Color(0xFF6A9955),
    documentationComment: Color(0xFF608B4E),

    // ─────────────────────────────────────────────
    // Operators & punctuation
    // ─────────────────────────────────────────────
    operator: Color(0xFFD4D4D4),
    arithmetic: Color(0xFFD4D4D4),
    comparison: Color(0xFFD4D4D4),
    logical: Color(0xFFC586C0),
    bitwise: Color(0xFFD4D4D4),
    assignment: Color(0xFFD4D4D4),
    increment: Color(0xFFD4D4D4),
    ternary: Color(0xFFD4D4D4),

    punctuation: Color(0xFFD4D4D4),
    comma: Color(0xFFD4D4D4),
    colon: Color(0xFFD4D4D4),
    semicolon: Color(0xFFD4D4D4),
    brackets: Color(0xFFD4D4D4),
    genericBrace: Color(0xFF808080),

    // ─────────────────────────────────────────────
    // Misc
    // ─────────────────────────────────────────────
    whitespace: Color(0x00000000), // invisible
    unknown: Color(0xFFFF0000), // bright red to expose bugs
  ),
);
