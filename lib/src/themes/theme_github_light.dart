import 'dart:ui';

import 'package:kalua/src/editor/editor_theme.dart';
import 'package:kalua/src/luau/themes/luau_theme.dart';
import 'package:kalua/src/themes/theme.dart';

const githubLightKaluaTheme = KaluaTheme(
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

  luauCodeTheme: LuauTheme(
    baseTextColor: Color(0xFF24292E),

    // ─────────────────────────────────────────────
    // Core syntax
    // ─────────────────────────────────────────────
    keyword: Color(0xFFD73A49), // red
    controlFlow: Color(0xFFD73A49), // red
    identifier: Color(0xFF24292E), // near-black
    functionName: Color(0xFF6F42C1), // purple
    typeName: Color(0xFF005CC5), // blue

    string: Color(0xFF032F62), // dark blue
    number: Color(0xFF005CC5), // blue
    boolean: Color(0xFF005CC5), // blue

    comment: Color(0xFF6A737D), // gray
    documentationComment: Color(0xFF6A737D),

    // ─────────────────────────────────────────────
    // Operators & punctuation
    // ─────────────────────────────────────────────
    operator: Color(0xFFD73A49),
    arithmetic: Color(0xFFD73A49),
    comparison: Color(0xFFD73A49),
    logical: Color(0xFFD73A49),
    bitwise: Color(0xFFD73A49),

    assignment: Color(0xFF005CC5), // slightly emphasized
    increment: Color(0xFFD73A49),
    ternary: Color(0xFFD73A49),

    punctuation: Color(0xFF24292E),
    comma: Color(0xFF24292E),
    colon: Color(0xFF24292E),
    semicolon: Color(0xFF24292E),

    brackets: Color(0xFF24292E),
    genericBrace: Color(0xFF005CC5), // type-related emphasis
    // ─────────────────────────────────────────────
    // Misc / fallback
    // ─────────────────────────────────────────────
    whitespace: Color(0xFFCED4DA),
    unknown: Color(0xFF24292E),
  ),
);
