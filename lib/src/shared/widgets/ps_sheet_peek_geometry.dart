import 'package:flutter/material.dart';

/// Bottom-edge silhouette for the slide-down sheet peek / grab header.
class PSSheetPeekGeometry {
  PSSheetPeekGeometry._();

  static const shoulderFraction = 0.30;
  static const dipDepth = 11.0;
  static const iconRowHeight = 36.0;
  static const handleHeight = 4.0;
  static const handleBottomMargin = 5.0;

  /// Body below the status-bar inset (icons + wavy bottom + pill).
  static const bodyHeight = iconRowHeight + dipDepth + handleBottomMargin;

  static double totalHeight(double topInset) => topInset + bodyHeight;

  /// Closed header shape — flat top, shoulders high, center dip with pill area.
  static Path headerPath(Size size) {
    final w = size.width;
    final h = size.height;
    final sw = w * shoulderFraction;
    final cx = w * 0.5;
    final shoulderY = h - dipDepth;
    final blend = sw * 0.5;

    return Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, shoulderY)
      ..cubicTo(
        w - sw + blend * 0.2,
        shoulderY,
        w - sw - blend * 0.15,
        h,
        cx + 28,
        h,
      )
      ..cubicTo(
        cx - 28,
        h,
        sw + blend * 0.15,
        h,
        sw - blend * 0.2,
        shoulderY,
      )
      ..lineTo(0, shoulderY)
      ..close();
  }
}

class PSSheetPeekClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => PSSheetPeekGeometry.headerPath(size);

  @override
  bool shouldReclip(PSSheetPeekClipper oldClipper) => false;
}
