import 'dart:ui';

class EditorTheme {
  const EditorTheme({
    required this.paneColor,
    required this.paneDividerColor,
    required this.background,
    required this.indentLineColor,
    required this.foreground,
    required this.caret,
    required this.selection,
    required this.inactiveSelection,
    required this.lineHighlight,
    required this.gutterBackground,
    required this.gutterBorder,
    required this.gutterForeground,
    required this.bracketHighlight,
    required this.invisibleCharacters,
  });

  // ─────────────────────────────────────────────
  // Editor / UI colors
  // ─────────────────────────────────────────────

  final Color paneColor;

  final Color paneDividerColor;

  /// Main editor background
  final Color background;

  /// The color of the vertical lines that are displayed in the editor for every
  /// tab of distance that code sits from the gutter.
  final Color indentLineColor;

  /// Default foreground text color
  final Color foreground;

  /// Caret / cursor color
  final Color caret;

  /// Selection background
  final Color selection;

  /// Inactive selection background
  final Color inactiveSelection;

  /// Line highlight (current line)
  final Color lineHighlight;

  /// Gutter background
  final Color gutterBackground;

  final Color gutterBorder;

  /// Gutter foreground (line numbers)
  final Color gutterForeground;

  /// Bracket pair highlight
  final Color bracketHighlight;

  /// Invisible characters (whitespace markers)
  final Color invisibleCharacters;
}
