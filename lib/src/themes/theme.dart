import 'package:kalua/src/editor/editor_theme.dart';
import 'package:kalua/src/luau/themes/luau_theme.dart';

class KaluaTheme {
  const KaluaTheme({required this.editorTheme, required this.luauCodeTheme});

  final EditorTheme editorTheme;
  final LuauTheme luauCodeTheme;
}
