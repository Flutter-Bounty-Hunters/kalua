import 'dart:math';
import 'dart:ui' hide TextStyle;

import 'package:flutter/material.dart' show TextStyle, FontStyle, FontWeight, Brightness, HSLColor;
import 'package:kalua/kalua.dart';

/// ─────────────────────────────────────────────────────────────
/// Public API
/// ─────────────────────────────────────────────────────────────

KaluaTheme generateKaluaTheme(ThemeGenerationPreference preference, {Brightness brightness = Brightness.dark}) {
  final Random rand = Random();
  final _StyleProfile profile = _profiles[preference]!;

  // Base hue: drives the whole palette
  final double baseHue = rand.nextDouble() * 360.0;

  // Editor background
  final double bgLightness = brightness == Brightness.dark
      ? _randRange(rand, 0.06, 0.14)
      : _randRange(rand, 0.88, 0.96);

  final Color background = _fromHSL(
    baseHue,
    preference == ThemeGenerationPreference.monochrome ? 0.15 : 0.2,
    bgLightness,
  );

  // Editor foreground (base text)
  final double fgLightness = brightness == Brightness.dark
      ? (bgLightness + profile.contrastDelta).clamp(0.0, 1.0)
      : (bgLightness - profile.contrastDelta).clamp(0.0, 1.0);

  final Color foreground = _fromHSL(
    baseHue,
    preference == ThemeGenerationPreference.monochrome ? 0.35 : 0.25,
    fgLightness,
  );

  final _AccentPalette accents = _generateAccents(baseHue, preference, brightness, profile, rand);

  // ─────────────────────────────────────────────
  // EditorTheme
  // ─────────────────────────────────────────────

  final EditorTheme editorTheme = EditorTheme(
    paneColor: background,
    paneDividerColor: background.withOpacity(0.9),
    indentLineColor: foreground.withOpacity(0.15),

    background: background,
    foreground: foreground,
    caret: accents.primary,

    selection: accents.primary.withOpacity(0.35),
    inactiveSelection: foreground.withOpacity(0.18),

    lineHighlight: foreground.withOpacity(0.06),

    gutterBackground: background,
    gutterBorder: foreground.withOpacity(0.12),
    gutterForeground: foreground.withOpacity(0.55),

    bracketHighlight: accents.brackets,
    invisibleCharacters: foreground.withOpacity(0.3),
  );

  // ─────────────────────────────────────────────
  // LuauTheme
  // ─────────────────────────────────────────────

  final TextStyle baseText = TextStyle(color: foreground);

  final LuauTheme luauTheme = LuauTheme(
    baseTextStyle: baseText,

    // Core syntax
    keyword: baseText.copyWith(color: accents.primary, fontWeight: FontWeight.bold),
    controlFlow: baseText.copyWith(color: accents.primary),
    identifier: baseText.copyWith(color: accents.identifier),
    functionName: baseText.copyWith(color: accents.function),
    typeName: baseText.copyWith(color: accents.type),

    string: baseText.copyWith(color: accents.string),
    number: baseText.copyWith(color: accents.number),
    boolean: baseText.copyWith(color: accents.number),

    comment: baseText.copyWith(color: accents.comment),
    documentationComment: baseText.copyWith(color: accents.comment, fontStyle: FontStyle.italic),

    // Operators & punctuation
    operator: baseText.copyWith(color: accents.operator),
    arithmetic: baseText.copyWith(color: accents.operator),
    comparison: baseText.copyWith(color: accents.operator),
    logical: baseText.copyWith(color: accents.operator),
    bitwise: baseText.copyWith(color: accents.operator),

    assignment: baseText.copyWith(color: accents.primary),
    increment: baseText.copyWith(color: accents.primary),
    ternary: baseText.copyWith(color: accents.primary),

    punctuation: baseText.copyWith(color: accents.punctuation),
    comma: baseText.copyWith(color: accents.punctuation),
    colon: baseText.copyWith(color: accents.punctuation),
    semicolon: baseText.copyWith(color: accents.punctuation),

    brackets: baseText.copyWith(color: accents.brackets),
    genericBrace: baseText.copyWith(color: accents.brackets),

    whitespace: baseText.copyWith(color: foreground.withOpacity(0.25)),
    unknown: baseText,
  );

  return KaluaTheme(brightness: brightness, editorTheme: editorTheme, luauTheme: luauTheme);
}

/// User-facing theme generation modes.
enum ThemeGenerationPreference { highContrast, vibrant, pastel, monochrome }

/// ─────────────────────────────────────────────────────────────
/// Accent generation
/// ─────────────────────────────────────────────────────────────

_AccentPalette _generateAccents(
  double baseHue,
  ThemeGenerationPreference preference,
  Brightness brightness,
  _StyleProfile profile,
  Random rand,
) {
  final double baseLight = brightness == Brightness.dark ? 0.6 : 0.4;

  // ─────────────────────────────────────────────
  // VIBRANT — playful, colorful, wide hue spread
  // ─────────────────────────────────────────────
  if (preference == ThemeGenerationPreference.vibrant) {
    double nextHue(double offset) => (baseHue + offset + rand.nextDouble() * 20) % 360;

    Color vivid(double h, double l) {
      return _fromHSL(h, _randRange(rand, 0.85, 1.0), l.clamp(0.35, 0.75));
    }

    return _AccentPalette(
      primary: vivid(nextHue(0), baseLight + 0.1),
      identifier: vivid(nextHue(100), baseLight),
      function: vivid(nextHue(200), baseLight + 0.15),
      type: vivid(nextHue(260), baseLight + 0.05),
      string: vivid(nextHue(40), baseLight + 0.2),
      number: vivid(nextHue(320), baseLight + 0.25),
      operator: vivid(nextHue(140), baseLight),
      punctuation: vivid(nextHue(180), baseLight - 0.05),
      brackets: vivid(nextHue(300), baseLight + 0.1),
      comment: _fromHSL(baseHue, 0.4, baseLight - 0.3),
    );
  }

  // ─────────────────────────────────────────────
  // MONOCHROME — single hue, varied saturation/lightness
  // ─────────────────────────────────────────────
  if (preference == ThemeGenerationPreference.monochrome) {
    return _AccentPalette(
      primary: _fromHSL(baseHue, 0.7, baseLight),
      identifier: _fromHSL(baseHue, 0.5, baseLight + 0.05),
      function: _fromHSL(baseHue, 0.8, baseLight + 0.15),
      type: _fromHSL(baseHue, 0.6, baseLight - 0.05),
      string: _fromHSL(baseHue, 0.55, baseLight + 0.2),
      number: _fromHSL(baseHue, 0.65, baseLight + 0.25),
      operator: _fromHSL(baseHue, 0.45, baseLight),
      punctuation: _fromHSL(baseHue, 0.4, baseLight),
      brackets: _fromHSL(baseHue, 0.75, baseLight + 0.1),
      comment: _fromHSL(baseHue, 0.3, baseLight - 0.3),
    );
  }

  // ─────────────────────────────────────────────
  // High contrast & pastel
  // ─────────────────────────────────────────────

  Color accent(double hueOffset) {
    return _fromHSL(baseHue + hueOffset, profile.sat(rand), profile.light(rand));
  }

  return _AccentPalette(
    primary: accent(0),
    identifier: accent(30),
    function: accent(60),
    type: accent(160),
    string: accent(90),
    number: accent(120),
    operator: accent(200),
    punctuation: _fromHSL(baseHue, 0.3, baseLight),
    brackets: accent(300),
    comment: _fromHSL(baseHue, 0.35, baseLight - 0.3),
  );
}

/// ─────────────────────────────────────────────────────────────
/// Data models & helpers
/// ─────────────────────────────────────────────────────────────

class _AccentPalette {
  const _AccentPalette({
    required this.primary,
    required this.identifier,
    required this.function,
    required this.type,
    required this.string,
    required this.number,
    required this.operator,
    required this.punctuation,
    required this.brackets,
    required this.comment,
  });

  final Color primary;
  final Color identifier;
  final Color function;
  final Color type;
  final Color string;
  final Color number;
  final Color operator;
  final Color punctuation;
  final Color brackets;
  final Color comment;
}

class _StyleProfile {
  const _StyleProfile({
    required this.saturationMin,
    required this.saturationMax,
    required this.lightnessMin,
    required this.lightnessMax,
    required this.contrastDelta,
  });

  final double saturationMin;
  final double saturationMax;
  final double lightnessMin;
  final double lightnessMax;
  final double contrastDelta;

  double sat(Random rand) => _randRange(rand, saturationMin, saturationMax);

  double light(Random rand) => _randRange(rand, lightnessMin, lightnessMax);
}

const Map<ThemeGenerationPreference, _StyleProfile> _profiles = {
  ThemeGenerationPreference.highContrast: _StyleProfile(
    saturationMin: 0.65,
    saturationMax: 1.0,
    lightnessMin: 0.15,
    lightnessMax: 0.85,
    contrastDelta: 0.65,
  ),
  ThemeGenerationPreference.vibrant: _StyleProfile(
    saturationMin: 0.75,
    saturationMax: 1.0,
    lightnessMin: 0.35,
    lightnessMax: 0.75,
    contrastDelta: 0.55,
  ),
  ThemeGenerationPreference.pastel: _StyleProfile(
    saturationMin: 0.25,
    saturationMax: 0.45,
    lightnessMin: 0.65,
    lightnessMax: 0.9,
    contrastDelta: 0.4,
  ),
  ThemeGenerationPreference.monochrome: _StyleProfile(
    saturationMin: 0.45,
    saturationMax: 0.85,
    lightnessMin: 0.25,
    lightnessMax: 0.8,
    contrastDelta: 0.6,
  ),
};

double _randRange(Random rand, double min, double max) {
  return min + rand.nextDouble() * (max - min);
}

Color _fromHSL(double h, double s, double l) {
  return HSLColor.fromAHSL(1.0, h % 360, s.clamp(0.0, 1.0), l.clamp(0.0, 1.0)).toColor();
}
