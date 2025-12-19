import 'package:flutter/material.dart' show Color, TextStyle;
import 'package:flutter/foundation.dart';
import 'package:kalua/src/editor/editor_theme.dart';
import 'package:kalua/src/luau/themes/luau_theme.dart';
import 'package:kalua/src/themes/theme.dart';

const blankSlateLight = KaluaTheme(
  brightness: Brightness.light,
  editorTheme: EditorTheme(
    paneColor: Color(0xFFF6F8FA),
    paneDividerColor: Color(0xFFE1E4E8),
    indentLineColor: Color(0xFFEAECEF),

    // ─────────────────────────────────────────────
    // Editor / UI
    // ─────────────────────────────────────────────
    background: Color(0xFFFFFFFF),
    foreground: Color(0xFF24292F),
    caret: Color(0xFF24292F),

    selection: Color(0x3324292F),
    inactiveSelection: Color(0x1F24292F),

    lineHighlight: Color(0x0F24292F),

    gutterBackground: Color(0xFFF6F8FA),
    gutterBorder: Color(0xFFE1E4E8),
    gutterForeground: Color(0xFF57606A),

    bracketHighlight: Color(0xFF24292F),
    invisibleCharacters: Color(0x4D24292F),
  ),

  luauTheme: LuauTheme(
    baseTextStyle: TextStyle(color: Color(0xFF24292F)),

    // ─────────────────────────────────────────────
    // Core syntax
    // ─────────────────────────────────────────────
    keyword: TextStyle(color: Color(0xFF24292F)),
    controlFlow: TextStyle(color: Color(0xFF24292F)),
    identifier: TextStyle(color: Color(0xFF24292F)),
    functionName: TextStyle(color: Color(0xFF24292F)),
    typeName: TextStyle(color: Color(0xFF24292F)),

    string: TextStyle(color: Color(0xFF24292F)),
    number: TextStyle(color: Color(0xFF24292F)),
    boolean: TextStyle(color: Color(0xFF24292F)),

    comment: TextStyle(color: Color(0xFF24292F)),
    documentationComment: TextStyle(color: Color(0xFF24292F)),

    // ─────────────────────────────────────────────
    // Operators & punctuation
    // ─────────────────────────────────────────────
    operator: TextStyle(color: Color(0xFF24292F)),
    arithmetic: TextStyle(color: Color(0xFF24292F)),
    comparison: TextStyle(color: Color(0xFF24292F)),
    logical: TextStyle(color: Color(0xFF24292F)),
    bitwise: TextStyle(color: Color(0xFF24292F)),

    assignment: TextStyle(color: Color(0xFF24292F)),
    increment: TextStyle(color: Color(0xFF24292F)),
    ternary: TextStyle(color: Color(0xFF24292F)),

    punctuation: TextStyle(color: Color(0xFF24292F)),
    comma: TextStyle(color: Color(0xFF24292F)),
    colon: TextStyle(color: Color(0xFF24292F)),
    semicolon: TextStyle(color: Color(0xFF24292F)),

    brackets: TextStyle(color: Color(0xFF24292F)),
    genericBrace: TextStyle(color: Color(0xFF24292F)),

    // ─────────────────────────────────────────────
    // Misc / fallback
    // ─────────────────────────────────────────────
    whitespace: TextStyle(color: Color(0xFF24292F)),
    unknown: TextStyle(color: Color(0xFF24292F)),
  ),
);

const blankSlateDark = KaluaTheme(
  brightness: Brightness.dark,
  editorTheme: EditorTheme(
    paneColor: Color(0xFF161B22),
    paneDividerColor: Color(0xFF0D1117),
    indentLineColor: Color(0xFF21262D),

    // ─────────────────────────────────────────────
    // Editor / UI
    // ─────────────────────────────────────────────
    background: Color(0xFF0D1117),
    foreground: Color(0xFFC9D1D9),
    caret: Color(0xFFC9D1D9),

    selection: Color(0x33C9D1D9),
    inactiveSelection: Color(0x1FC9D1D9),

    lineHighlight: Color(0x0FC9D1D9),

    gutterBackground: Color(0xFF161B22),
    gutterBorder: Color(0xFF30363D),
    gutterForeground: Color(0xFF8B949E),

    bracketHighlight: Color(0xFFC9D1D9),
    invisibleCharacters: Color(0x4DC9D1D9),
  ),

  luauTheme: LuauTheme(
    baseTextStyle: TextStyle(color: Color(0xFFC9D1D9)),

    // ─────────────────────────────────────────────
    // Core syntax
    // ─────────────────────────────────────────────
    keyword: TextStyle(color: Color(0xFFC9D1D9)),
    controlFlow: TextStyle(color: Color(0xFFC9D1D9)),
    identifier: TextStyle(color: Color(0xFFC9D1D9)),
    functionName: TextStyle(color: Color(0xFFC9D1D9)),
    typeName: TextStyle(color: Color(0xFFC9D1D9)),

    string: TextStyle(color: Color(0xFFC9D1D9)),
    number: TextStyle(color: Color(0xFFC9D1D9)),
    boolean: TextStyle(color: Color(0xFFC9D1D9)),

    comment: TextStyle(color: Color(0xFFC9D1D9)),
    documentationComment: TextStyle(color: Color(0xFFC9D1D9)),

    // ─────────────────────────────────────────────
    // Operators & punctuation
    // ─────────────────────────────────────────────
    operator: TextStyle(color: Color(0xFFC9D1D9)),
    arithmetic: TextStyle(color: Color(0xFFC9D1D9)),
    comparison: TextStyle(color: Color(0xFFC9D1D9)),
    logical: TextStyle(color: Color(0xFFC9D1D9)),
    bitwise: TextStyle(color: Color(0xFFC9D1D9)),

    assignment: TextStyle(color: Color(0xFFC9D1D9)),
    increment: TextStyle(color: Color(0xFFC9D1D9)),
    ternary: TextStyle(color: Color(0xFFC9D1D9)),

    punctuation: TextStyle(color: Color(0xFFC9D1D9)),
    comma: TextStyle(color: Color(0xFFC9D1D9)),
    colon: TextStyle(color: Color(0xFFC9D1D9)),
    semicolon: TextStyle(color: Color(0xFFC9D1D9)),

    brackets: TextStyle(color: Color(0xFFC9D1D9)),
    genericBrace: TextStyle(color: Color(0xFFC9D1D9)),

    // ─────────────────────────────────────────────
    // Misc / fallback
    // ─────────────────────────────────────────────
    whitespace: TextStyle(color: Color(0xFFC9D1D9)),
    unknown: TextStyle(color: Color(0xFFC9D1D9)),
  ),
);
