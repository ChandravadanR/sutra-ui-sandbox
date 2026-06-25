import 'package:flutter/material.dart';

class SutraShapes extends ThemeExtension<SutraShapes> {
  const SutraShapes({
    required this.cornerSm,
    required this.cornerMd,
    required this.cornerLg,
    required this.cornerXl,
    required this.cornerFull,
    required this.borderThin,
    required this.borderRegular,
    required this.borderThick,
  });
  final BorderRadius cornerSm;
  final BorderRadius cornerMd;
  final BorderRadius cornerLg;
  final BorderRadius cornerXl;
  final BorderRadius cornerFull;

  final double borderThin;
  final double borderRegular;
  final double borderThick;

  static const sutra = SutraShapes(
    cornerSm: BorderRadius.all(Radius.circular(4)),
    cornerMd: BorderRadius.all(Radius.circular(8)),
    cornerLg: BorderRadius.all(Radius.circular(12)),
    cornerXl: BorderRadius.all(Radius.circular(16)),
    cornerFull: BorderRadius.all(Radius.circular(9999)),
    borderThin: 0.5,
    borderRegular: 1,
    borderThick: 2,
  );

  @override
  SutraShapes copyWith({
    BorderRadius? cornerSm,
    BorderRadius? cornerMd,
    BorderRadius? cornerLg,
    BorderRadius? cornerXl,
    BorderRadius? cornerFull,
    double? borderThin,
    double? borderRegular,
    double? borderThick,
  }) {
    return SutraShapes(
      cornerSm: cornerSm ?? this.cornerSm,
      cornerMd: cornerMd ?? this.cornerMd,
      cornerLg: cornerLg ?? this.cornerLg,
      cornerXl: cornerXl ?? this.cornerXl,
      cornerFull: cornerFull ?? this.cornerFull,
      borderThin: borderThin ?? this.borderThin,
      borderRegular: borderRegular ?? this.borderRegular,
      borderThick: borderThick ?? this.borderThick,
    );
  }

  @override
  SutraShapes lerp(ThemeExtension<SutraShapes>? other, double t) {
    if (other is! SutraShapes) return this;

    return SutraShapes(
      cornerSm: BorderRadius.lerp(cornerSm, other.cornerSm, t)!,
      cornerMd: BorderRadius.lerp(cornerMd, other.cornerMd, t)!,
      cornerLg: BorderRadius.lerp(cornerLg, other.cornerLg, t)!,
      cornerXl: BorderRadius.lerp(cornerXl, other.cornerXl, t)!,
      cornerFull: BorderRadius.lerp(cornerFull, other.cornerFull, t)!,
      borderThin: lerpDouble(borderThin, other.borderThin, t)!,
      borderRegular: lerpDouble(borderRegular, other.borderRegular, t)!,
      borderThick: lerpDouble(borderThick, other.borderThick, t)!,
    );
  }

  // Helper for double lerp
  double? lerpDouble(num? a, num? b, double t) {
    if (a == b || (a == null && b == null)) return a?.toDouble();
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }
}
