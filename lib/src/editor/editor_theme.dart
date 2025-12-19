import 'dart:ui';

class EditorTheme {
  factory EditorTheme.fromJson(Map<String, dynamic> json) {
    return EditorTheme(
      paneColor: Color(json['paneColor']),
      paneDividerColor: Color(json['paneDividerColor']),
      indentLineColor: Color(json['indentLineColor']),

      background: Color(json['background']),
      foreground: Color(json['foreground']),
      caret: Color(json['caret']),
      selection: Color(json['selection']),
      inactiveSelection: Color(json['inactiveSelection']),
      lineHighlight: Color(json['lineHighlight']),

      gutterBackground: Color(json['gutterBackground']),
      gutterBorder: Color(json['gutterBorder']),
      gutterForeground: Color(json['gutterForeground']),

      bracketHighlight: Color(json['bracketHighlight']),
      invisibleCharacters: Color(json['invisibleCharacters']),
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      'paneColor': paneColor.toARGB32(),
      'paneDividerColor': paneDividerColor.toARGB32(),
      'indentLineColor': indentLineColor.toARGB32(),

      'background': background.toARGB32(),
      'foreground': foreground.toARGB32(),
      'caret': caret.toARGB32(),
      'selection': selection.toARGB32(),
      'inactiveSelection': inactiveSelection.toARGB32(),
      'lineHighlight': lineHighlight.toARGB32(),

      'gutterBackground': gutterBackground.toARGB32(),
      'gutterBorder': gutterBorder.toARGB32(),
      'gutterForeground': gutterForeground.toARGB32(),

      'bracketHighlight': bracketHighlight.toARGB32(),
      'invisibleCharacters': invisibleCharacters.toARGB32(),
    };
  }
}
