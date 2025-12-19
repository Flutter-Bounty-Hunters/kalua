import 'dart:ui';

import 'package:kalua/src/editor/editor_theme.dart';
import 'package:kalua/src/luau/themes/luau_theme.dart';

class KaluaTheme {
  factory KaluaTheme.fromJson(Map<String, dynamic> json) {
    return KaluaTheme(
      brightness: json['brightness'] == 'light' ? Brightness.light : Brightness.dark,
      editorTheme: EditorTheme.fromJson(json['editorTheme']),
      luauTheme: LuauTheme.fromJson(json['luauTheme']),
    );
  }

  const KaluaTheme({required this.brightness, required this.editorTheme, required this.luauTheme});

  final Brightness brightness;
  bool get isLight => brightness == Brightness.light;
  bool get isDark => brightness == Brightness.dark;

  final EditorTheme editorTheme;

  final LuauTheme luauTheme;

  Map<String, dynamic> toJson() {
    return {'brightness': brightness.name, 'editorTheme': editorTheme.toJson(), 'luauTheme': luauTheme.toJson()};
  }
}
