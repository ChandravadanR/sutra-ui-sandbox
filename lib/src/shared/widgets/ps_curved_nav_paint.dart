import 'package:flutter/material.dart';

/// Shared curved-top path used by [PSStyleBottomNav] and [PSCompactBottomNav].
Path psCurvedTopPath(Size size, double peakY) {
  return Path()
    ..moveTo(0, peakY)
    ..quadraticBezierTo(size.width / 2, 0, size.width, peakY)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close();
}

class PSCurvedTopClipper extends CustomClipper<Path> {
  const PSCurvedTopClipper({required this.peakY});

  final double peakY;

  @override
  Path getClip(Size size) => psCurvedTopPath(size, peakY);

  @override
  bool shouldReclip(PSCurvedTopClipper oldClipper) =>
      oldClipper.peakY != peakY;
}

class PSCurvedTopPainter extends CustomPainter {
  const PSCurvedTopPainter({
    required this.peakY,
    required this.fillColor,
  });

  final double peakY;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      psCurvedTopPath(size, peakY),
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(PSCurvedTopPainter oldDelegate) =>
      oldDelegate.peakY != peakY || oldDelegate.fillColor != fillColor;
}
