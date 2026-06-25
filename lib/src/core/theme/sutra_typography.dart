import 'package:flutter/material.dart';

class SutraTypography extends ThemeExtension<SutraTypography> {
  const SutraTypography({
    required this.fontFamily,
    required this.fontFamilyMono,
    required this.fontFamilyRtl,
    required this.bodySize,
    required this.bodyWeight,
    required this.bodyLineHeight,
    required this.captionSize,
    required this.captionWeight,
    required this.heading1Size,
    required this.heading1Weight,
    required this.heading2Size,
    required this.heading2Weight,
    required this.labelSize,
    required this.labelWeight,
  });
  final String fontFamily;
  final String fontFamilyMono;
  final String fontFamilyRtl;

  final double bodySize;
  final FontWeight bodyWeight;
  final double bodyLineHeight;

  final double captionSize;
  final FontWeight captionWeight;

  final double heading1Size;
  final FontWeight heading1Weight;

  final double heading2Size;
  final FontWeight heading2Weight;

  final double labelSize;
  final FontWeight labelWeight;

  static const sutra = SutraTypography(
    fontFamily: 'Inter',
    fontFamilyMono: 'JetBrains Mono',
    fontFamilyRtl: 'NotoSansUrdu',
    bodySize: 15,
    bodyWeight: FontWeight.w400,
    bodyLineHeight: 1.5,
    captionSize: 13,
    captionWeight: FontWeight.w400,
    heading1Size: 24,
    heading1Weight: FontWeight.w700,
    heading2Size: 20,
    heading2Weight: FontWeight.w600,
    labelSize: 13,
    labelWeight: FontWeight.w500,
  );

  @override
  SutraTypography copyWith({
    String? fontFamily,
    String? fontFamilyMono,
    String? fontFamilyRtl,
    double? bodySize,
    FontWeight? bodyWeight,
    double? bodyLineHeight,
    double? captionSize,
    FontWeight? captionWeight,
    double? heading1Size,
    FontWeight? heading1Weight,
    double? heading2Size,
    FontWeight? heading2Weight,
    double? labelSize,
    FontWeight? labelWeight,
  }) {
    return SutraTypography(
      fontFamily: fontFamily ?? this.fontFamily,
      fontFamilyMono: fontFamilyMono ?? this.fontFamilyMono,
      fontFamilyRtl: fontFamilyRtl ?? this.fontFamilyRtl,
      bodySize: bodySize ?? this.bodySize,
      bodyWeight: bodyWeight ?? this.bodyWeight,
      bodyLineHeight: bodyLineHeight ?? this.bodyLineHeight,
      captionSize: captionSize ?? this.captionSize,
      captionWeight: captionWeight ?? this.captionWeight,
      heading1Size: heading1Size ?? this.heading1Size,
      heading1Weight: heading1Weight ?? this.heading1Weight,
      heading2Size: heading2Size ?? this.heading2Size,
      heading2Weight: heading2Weight ?? this.heading2Weight,
      labelSize: labelSize ?? this.labelSize,
      labelWeight: labelWeight ?? this.labelWeight,
    );
  }

  @override
  SutraTypography lerp(ThemeExtension<SutraTypography>? other, double t) {
    if (other is! SutraTypography) return this;

    return SutraTypography(
      fontFamily: other.fontFamily, // No lerping for font family strings
      fontFamilyMono: other.fontFamilyMono,
      fontFamilyRtl: other.fontFamilyRtl,
      bodySize: lerpDouble(bodySize, other.bodySize, t)!,
      bodyWeight: FontWeight.lerp(bodyWeight, other.bodyWeight, t)!,
      bodyLineHeight: lerpDouble(bodyLineHeight, other.bodyLineHeight, t)!,
      captionSize: lerpDouble(captionSize, other.captionSize, t)!,
      captionWeight: FontWeight.lerp(captionWeight, other.captionWeight, t)!,
      heading1Size: lerpDouble(heading1Size, other.heading1Size, t)!,
      heading1Weight: FontWeight.lerp(heading1Weight, other.heading1Weight, t)!,
      heading2Size: lerpDouble(heading2Size, other.heading2Size, t)!,
      heading2Weight: FontWeight.lerp(heading2Weight, other.heading2Weight, t)!,
      labelSize: lerpDouble(labelSize, other.labelSize, t)!,
      labelWeight: FontWeight.lerp(labelWeight, other.labelWeight, t)!,
    );
  }

  // Helper for double lerp
  double? lerpDouble(num? a, num? b, double t) {
    if (a == b || (a == null && b == null)) return a?.toDouble();
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }

  // ── Material-3 named text styles ────────────────────────────────────────
  // Composable shortcuts mapping the underlying sizes/weights to the
  // Material-3 naming used across feature code. All return TextStyle so
  // callers can `.copyWith(color: …)` without losing the family.
  TextStyle get _base => TextStyle(fontFamily: fontFamily);

  TextStyle get headlineLarge => _base.copyWith(
    fontSize: heading1Size + 6,
    fontWeight: heading1Weight,
  );
  TextStyle get headlineMedium => _base.copyWith(
    fontSize: heading1Size,
    fontWeight: heading1Weight,
  );
  TextStyle get headlineSmall => _base.copyWith(
    fontSize: heading2Size + 2,
    fontWeight: heading2Weight,
  );

  TextStyle get titleLarge => _base.copyWith(
    fontSize: heading2Size,
    fontWeight: heading2Weight,
  );
  TextStyle get titleMedium => _base.copyWith(
    fontSize: heading2Size - 2,
    fontWeight: FontWeight.w600,
  );
  TextStyle get titleSmall => _base.copyWith(
    fontSize: bodySize + 1,
    fontWeight: FontWeight.w600,
  );

  TextStyle get bodyLarge => _base.copyWith(
    fontSize: bodySize + 1,
    fontWeight: bodyWeight,
    height: bodyLineHeight,
  );
  TextStyle get bodyMedium => _base.copyWith(
    fontSize: bodySize,
    fontWeight: bodyWeight,
    height: bodyLineHeight,
  );
  TextStyle get bodySmall => _base.copyWith(
    fontSize: captionSize,
    fontWeight: bodyWeight,
    height: bodyLineHeight,
  );

  TextStyle get labelLarge => _base.copyWith(
    fontSize: labelSize + 1,
    fontWeight: FontWeight.w600,
  );
  TextStyle get labelMedium => _base.copyWith(
    fontSize: labelSize,
    fontWeight: labelWeight,
  );
  TextStyle get labelSmall => _base.copyWith(
    fontSize: labelSize - 2,
    fontWeight: labelWeight,
  );
}
