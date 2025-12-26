import 'package:example/theme_generator.dart';
import 'package:flutter/material.dart';
import 'package:kalua/kalua.dart';

class ThemeConfiguratorPane extends StatefulWidget {
  const ThemeConfiguratorPane({super.key, required this.theme, required this.onThemeChange});

  final KaluaTheme theme;

  final void Function(KaluaTheme newTheme) onThemeChange;

  @override
  State<ThemeConfiguratorPane> createState() => _ThemeConfiguratorPaneState();
}

class _ThemeConfiguratorPaneState extends State<ThemeConfiguratorPane> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      decoration: BoxDecoration(
        color: widget.theme.editorTheme.background,
        border: Border(left: BorderSide(color: Colors.black.withValues(alpha: 0.1), width: 2)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Theme generators
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      widget.onThemeChange(generateKaluaTheme(ThemeGenerationPreference.vibrant));
                    },
                    child: Text("Vibrant"),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      widget.onThemeChange(generateKaluaTheme(ThemeGenerationPreference.pastel));
                    },
                    child: Text("Pastel"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () {
                      widget.onThemeChange(generateKaluaTheme(ThemeGenerationPreference.highContrast));
                    },
                    child: Text("High-Contrast"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () {
                      widget.onThemeChange(generateKaluaTheme(ThemeGenerationPreference.monochrome));
                    },
                    child: Text("Monochrome"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Theme colors
            for (final tokenGroup in _tokenTypeListOrder.entries) ...[
              _buildGroupTitle(tokenGroup.key),
              for (final tokenType in tokenGroup.value) //
                _TokenColorListItem(theme: widget.theme, tokenType: tokenType),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGroupTitle(String title) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(title));
  }
}

class _TokenColorListItem extends StatelessWidget {
  const _TokenColorListItem({required this.theme, required this.tokenType});

  final KaluaTheme theme;
  final SemanticKind tokenType;

  @override
  Widget build(BuildContext context) {
    final color = theme.luauTheme.styleForSemanticKind(tokenType).color;

    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
      title: Text(_name, style: TextStyle(color: color)),
    );
  }

  String get _name => switch (tokenType) {
    SemanticKind.docComment => "Doc Comments",
    SemanticKind.comment => "Comments",
    SemanticKind.annotation => "Annotations",
    SemanticKind.typeName => "Type Names",
    SemanticKind.moduleName => "Modules",
    SemanticKind.className => "Class Names",
    SemanticKind.functionName => "Function Names",
    SemanticKind.propertyName => "Property Names",
    SemanticKind.keyword => "Keywords",
    SemanticKind.identifier => "Identifiers",
    SemanticKind.declaration => "Declarations",
    SemanticKind.visibility => "Visibility",
    SemanticKind.string => "Strings",
    SemanticKind.number => "Numbers",
    SemanticKind.boolean => "Booleans",
    SemanticKind.character => "Characters",
    SemanticKind.regex => "Regex",
    SemanticKind.enumMember => "Enum Members",
    SemanticKind.controlFlow => "Control Flow",
    SemanticKind.operator => "Operators",
    SemanticKind.assignment => "Assignments",
    SemanticKind.comparison => "Comparisons",
    SemanticKind.arithmetic => "Arithmetic",
    SemanticKind.logical => "Logical",
    SemanticKind.bitwise => "Bitwise",
    SemanticKind.increment => "Increment",
    SemanticKind.ternary => "Ternary",
    SemanticKind.punctuation => "Punctuation",
    SemanticKind.brackets => "Brackets",
    SemanticKind.genericBrace => "Braces",
    SemanticKind.comma => "Commas",
    SemanticKind.colon => "Colons",
    SemanticKind.semicolon => "Semicolons",
    SemanticKind.nullValue => "Null",
    SemanticKind.whitespace => "Whitespace",
    SemanticKind.unknown => "Unknown",
    SemanticKind.error => "Errors",
  };
}

const _tokenTypeListOrder = {
  'Meta': [SemanticKind.docComment, SemanticKind.comment, SemanticKind.annotation],
  'Language': [SemanticKind.keyword, SemanticKind.identifier, SemanticKind.typeName],
  'Structure': [
    SemanticKind.moduleName,
    SemanticKind.className,
    SemanticKind.functionName,
    SemanticKind.propertyName,
    SemanticKind.visibility,
    SemanticKind.brackets,
    SemanticKind.genericBrace,
    SemanticKind.declaration,
    SemanticKind.controlFlow,
  ],
  'Operators': [
    SemanticKind.operator,
    SemanticKind.assignment,
    SemanticKind.comparison,
    SemanticKind.arithmetic,
    SemanticKind.logical,
    SemanticKind.bitwise,
    SemanticKind.increment,
    SemanticKind.ternary,
  ],
  'Variables': [
    SemanticKind.string,
    SemanticKind.number,
    SemanticKind.boolean,
    SemanticKind.character,
    SemanticKind.regex,
    SemanticKind.enumMember,
  ],
  'Syntax': [SemanticKind.punctuation, SemanticKind.comma, SemanticKind.colon, SemanticKind.semicolon],
  'Misc': [SemanticKind.nullValue, SemanticKind.whitespace, SemanticKind.unknown, SemanticKind.error],
};
