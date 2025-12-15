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
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: widget.currentTheme,
      items: [
        DropdownMenuItem(value: githubLightKaluaTheme, child: Text('GitHub Light')),
        DropdownMenuItem(value: obsidianKaluaTheme, child: Text('Obsidian')),
      ],
      onChanged: widget.onThemeSelected,
    );
  }
}
