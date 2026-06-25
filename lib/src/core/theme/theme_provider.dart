import 'package:flutter/material.dart';

export 'sutra_colors.dart';
export 'sutra_typography.dart';
export 'sutra_shapes.dart';

import 'sutra_colors.dart';
import 'sutra_typography.dart';
import 'sutra_shapes.dart';

/// SANDBOX-ONLY theme builder.
///
/// In the real app the theme is produced by a Riverpod `ThemeNotifier` with
/// persistence, Google Fonts and multiple theme variants. The sandbox doesn't
/// need any of that, so this is a plain function that returns the dark theme
/// with the same `SutraColors` / `SutraTypography` / `SutraShapes` extensions.
///
/// The `context.sutraColors` / `.sutraTypography` / `.sutraShapes` accessors
/// below are IDENTICAL to the real app, so widgets copied from the app compile
/// here unchanged.
ThemeData buildSutraTheme() {
  const colors = SutraColors.sutraDark;
  const typography = SutraTypography.sutra;
  const shapes = SutraShapes.sutra;

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: colors.background,
    fontFamily: typography.fontFamily,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.secondary,
      onSecondary: colors.onSecondary,
      error: colors.error,
      onError: colors.onError,
      surface: colors.surface,
      onSurface: colors.onSurface,
      outline: colors.outline,
    ),
  );

  return base.copyWith(
    extensions: const <ThemeExtension<dynamic>>[colors, typography, shapes],
  );
}

// Convenience accessor — copied verbatim from the real app.
extension SutraThemeExtension on BuildContext {
  SutraColors get sutraColors => Theme.of(this).extension<SutraColors>()!;
  SutraTypography get sutraTypography =>
      Theme.of(this).extension<SutraTypography>()!;
  SutraShapes get sutraShapes => Theme.of(this).extension<SutraShapes>()!;
}
