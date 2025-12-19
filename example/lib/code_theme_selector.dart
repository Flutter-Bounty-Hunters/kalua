import 'package:collection/collection.dart' show IterableExtension;
import 'package:example/infrastructure/ui_kit/dropdown_list.dart';
import 'package:flutter/material.dart';
import 'package:kalua/kalua.dart';

class CodeThemeSelector extends StatefulWidget {
  const CodeThemeSelector({super.key, this.currentTheme, required this.onThemeSelected});

  final KaluaTheme? currentTheme;
  final void Function(KaluaTheme?) onThemeSelected;

  @override
  State<CodeThemeSelector> createState() => _CodeThemeSelectorState();
}

class _CodeThemeSelectorState extends State<CodeThemeSelector> {
  final _themes = [
    _ThemeListItemViewModel(
      key: GlobalKey(),
      theme: githubLightKaluaTheme,
      icon: SizedBox(width: 24, height: 30, child: Icon(Icons.light_mode, size: 14)),
      name: "GitHub Light",
    ),
    _ThemeListItemViewModel(
      key: GlobalKey(),
      theme: obsidianKaluaTheme,
      icon: SizedBox(width: 24, height: 30, child: Icon(Icons.dark_mode, size: 14)),
      name: "Obsidian",
    ),
    _ThemeListItemViewModel(
      key: GlobalKey(),
      theme: pineappleTheme,
      icon: SizedBox(
        width: 24,
        height: 30,
        child: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Center(child: Text("🍍", style: TextStyle(fontSize: 20))),
        ),
      ),
      name: "Pineapple",
    ),
    _ThemeListItemViewModel(
      key: GlobalKey(),
      theme: blankSlateLight,
      icon: SizedBox(width: 24, height: 30, child: Icon(Icons.light_mode, size: 14)),
      name: "Blank Slight (Light)",
    ),
    _ThemeListItemViewModel(
      key: GlobalKey(),
      theme: blankSlateDark,
      icon: SizedBox(width: 24, height: 30, child: Icon(Icons.dark_mode, size: 14)),
      name: "Blank Slight (Dark)",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownList<_ThemeListItemViewModel>(
      selectedItem: _themes.firstWhereOrNull((viewModel) => viewModel.theme == widget.currentTheme),
      items: _themes,
      hint: "Select Theme",
      listItemBuilder: (context, viewModel) {
        return Text(viewModel.name);
      },
      onItemSelected: (selectedItem) => widget.onThemeSelected(selectedItem.theme),
    );
  }
}

class _ThemeListItemViewModel {
  const _ThemeListItemViewModel({required this.key, required this.theme, this.icon, required this.name});

  final GlobalKey key;

  final KaluaTheme theme;

  final Widget? icon;
  final String name;
}
