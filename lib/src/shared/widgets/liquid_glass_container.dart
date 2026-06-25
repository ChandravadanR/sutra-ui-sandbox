import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sutra_mobile/src/core/theme/theme_provider.dart';

/// SANDBOX stub of the real `LiquidGlassContainer`.
///
/// Same constructor surface as the app's version so copied widgets compile
/// unchanged, but the Riverpod `appearanceProvider` dependency (glass on/off
/// toggle) is removed — glass blur is always on here.
class LiquidGlassContainer extends StatelessWidget {
  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.fillColor,
    this.fillOpacity,
    this.blurRadius,
    this.borderColor,
  });
  final Widget child;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor;
  final double? fillOpacity;
  final double? blurRadius;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.sutraColors;

    final effectiveBlur = blurRadius ?? colors.glassBlurRadius;
    final effectiveFillColor = (fillColor ?? colors.surface).withValues(
      alpha: fillOpacity ?? colors.glassSurfaceOpacity,
    );
    final effectiveBorderColor = borderColor ?? colors.glassBorderColor;
    final effectiveRadius = borderRadius ?? BorderRadius.circular(0);

    final containerWidget = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveFillColor,
        borderRadius: effectiveRadius,
        border: Border.all(
          color: effectiveBorderColor,
        ),
      ),
      child: child,
    );

    if (effectiveBlur <= 0.0) {
      return ClipRRect(
        borderRadius: effectiveRadius,
        child: containerWidget,
      );
    }

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
        child: containerWidget,
      ),
    );
  }
}
