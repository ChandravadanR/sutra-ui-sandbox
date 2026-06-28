import 'package:flutter/material.dart';

/// Which side tab is active on [PSCompactBottomNav].
enum PSCompactTab { chat, friends }

/// Compact nav geometry — shorter rail + screen-tab extension.
class PSCompactNavGeometry {
  PSCompactNavGeometry._();

  static const activeFraction = 0.38;

  /// Shorter nav rail (was 90px).
  static const barHeight = 56.0;

  /// Active tab extends into sheet content — part of the screen layer.
  static const tabScreenExtension = 22.0;

  static const contentNavGap = 12.0;
  static const bottomCornerRadius = 22.0;

  /// Shoulder width fraction + center peak depth — mirrors peek header silhouette.
  static const shoulderFraction = 0.30;
  static const peakDepth = 11.0;

  static const tabTopLeftRadius = 18.0;
  static const tabTopRightRadius = 32.0;
  static const tabBottomLeftRadius = 18.0;

  static const sheetColor = Color(0xFF1A0B10);
  static const sheetGapColor = Color(0xFF120810);
  static const navGradientTop = Color(0xFF2E0B16);
  static const navGradientBottom = Color(0xFF1F0812);
  static const badgeGreen = Color(0xFF1DB954);
  static const chevronMuted = Color(0xFF9D8189);

  static const tabFill = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A0B10), Color(0xFF1A0B10)],
  );

  static double totalHeight(double bottomInset) => barHeight + bottomInset;

  /// How far the active tab rises above the nav into the sheet.
  static double screenTabOverhang(double bottomInset) =>
      tabScreenExtension;

  static double contentBottomInset(double bottomInset) =>
      totalHeight(bottomInset) + contentNavGap + tabScreenExtension + 4;

  static double tForTab(PSCompactTab tab) =>
      tab == PSCompactTab.chat ? 0.0 : 1.0;

  static double activeTabWidth(double totalWidth) =>
      totalWidth * activeFraction;

  static double activeTabLeft(double totalWidth, double t) =>
      (totalWidth - activeTabWidth(totalWidth)) * t;

  /// Active tab layer height (nav row + extension into sheet).
  static double activeTabLayerHeight(double bottomInset) =>
      barHeight + tabScreenExtension;

  /// Open-sheet nav rail — peaked center (chevron), lower shoulders, rounded bottom.
  static Path navBarPath(Size size, {double bottomInset = 0}) {
    final w = size.width;
    final h = size.height;
    final r = bottomCornerRadius;
    final barBottom = h - bottomInset;
    final sw = w * shoulderFraction;
    final cx = w * 0.5;
    final shoulderY = peakDepth;
    final blend = sw * 0.5;

    return Path()
      ..moveTo(0, shoulderY)
      ..lineTo(0, barBottom - r)
      ..arcToPoint(Offset(r, barBottom), radius: Radius.circular(r))
      ..lineTo(w - r, barBottom)
      ..arcToPoint(Offset(w, barBottom - r), radius: Radius.circular(r))
      ..lineTo(w, shoulderY)
      ..cubicTo(
        w - sw + blend * 0.2,
        shoulderY,
        w - sw - blend * 0.15,
        0,
        cx + 28,
        0,
      )
      ..cubicTo(
        cx - 28,
        0,
        sw + blend * 0.15,
        0,
        sw - blend * 0.2,
        shoulderY,
      )
      ..lineTo(0, shoulderY)
      ..close();
  }
}

/// Burgundy nav rail — peaked top with center chevron slot (reference PS Chats).
class PSCompactNavBarPainter extends CustomPainter {
  PSCompactNavBarPainter({this.bottomInset = 0});

  final double bottomInset;

  @override
  void paint(Canvas canvas, Size size) {
    final path = PSCompactNavGeometry.navBarPath(size, bottomInset: bottomInset);

    canvas.drawShadow(
      path,
      Colors.black.withValues(alpha: 0.5),
      8,
      false,
    );
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            PSCompactNavGeometry.navGradientTop,
            PSCompactNavGeometry.navGradientBottom,
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  @override
  bool shouldRepaint(PSCompactNavBarPainter old) =>
      old.bottomInset != bottomInset;
}

/// Sheet-colour active tab — rendered in the sheet layer above the rail.
class PSCompactActiveTabPainter extends CustomPainter {
  PSCompactActiveTabPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final chatSide = t < 0.5;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, size.width, size.height),
          topLeft: Radius.circular(
            chatSide
                ? PSCompactNavGeometry.tabTopLeftRadius
                : PSCompactNavGeometry.tabTopRightRadius,
          ),
          topRight: Radius.circular(
            chatSide
                ? PSCompactNavGeometry.tabTopRightRadius
                : PSCompactNavGeometry.tabTopLeftRadius,
          ),
          bottomLeft: Radius.circular(
            chatSide ? PSCompactNavGeometry.tabBottomLeftRadius : 0,
          ),
          bottomRight: Radius.circular(
            chatSide ? 0 : PSCompactNavGeometry.tabBottomLeftRadius,
          ),
        ),
      );

    canvas.drawPath(
      path,
      Paint()
        ..shader = PSCompactNavGeometry.tabFill.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height),
        ),
    );
  }

  @override
  bool shouldRepaint(PSCompactActiveTabPainter old) => old.t != t;
}
