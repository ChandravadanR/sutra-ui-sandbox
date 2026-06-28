import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sutra_mobile/src/shared/widgets/ps_curved_nav_paint.dart';

/// PlayStation App–style custom bottom navigation.
///
/// Two layered curved-top panels stacked together:
///   • Label strip (very bottom): a slim strip showing only the active tab name
///   • Icon bar (above it):        the 5 tabs, curved top edge, drawn on top and
///                                 overlapping the label strip slightly.
///
/// Fully custom — built with [Stack], [CustomPaint], [CustomClipper] and
/// All colors come from the app theme where noted; nav panels use PS-style
/// burgundy from the reference screenshot.
class PSStyleBottomNav extends StatefulWidget {
  const PSStyleBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    this.visibility = 1.0,
  });

  /// Active tab index (controlled by the parent).
  final int selectedIndex;

  /// Fired when a tab is tapped.
  final ValueChanged<int> onTabChanged;

  /// 0 = fully hidden off-screen (scrolled away), 1 = fully visible.
  final double visibility;

  @override
  State<PSStyleBottomNav> createState() => _PSStyleBottomNavState();
}

class _PSStyleBottomNavState extends State<PSStyleBottomNav>
    with SingleTickerProviderStateMixin {
  // ── Geometry ────────────────────────────────────────────────────────────
  static const double _iconBarHeight = 70;
  static const double _labelStripHeight = 56;
  static const double _overlap = 12;
  // Both panels share the exact same curved-top arch (rounder = bigger peak).
  static const double _iconBarPeakY = 28;
  static const double _labelPeakY = 28;
  static const double _capsuleWidth = 32;
  static const double _capsuleHeight = 3;
  static const double _activeGlowReach = 42;
  static const double _totalHeight =
      _iconBarHeight + _labelStripHeight - _overlap;

  // Icons sit higher toward the center to follow the curved top edge.
  static const List<double> _iconMarginBottom = [6, 12, 18, 12, 6];

  // PS App burgundy nav palette (reference screenshot).
  static const Color _iconBarColor = Color(0xFF2E0B16);
  static const Color _titleStripColor = Color(0xFF1F0812);
  static const Color _activeAccent = Color(0xFFE8196A);

  static const List<_PSNavTab> _tabs = [
    _PSNavTab(icon: Icons.sports_esports, label: 'Play'),
    _PSNavTab(icon: Icons.explore, label: 'Explore'),
    _PSNavTab(icon: Icons.shopping_bag, label: 'Store'),
    _PSNavTab(icon: Icons.grid_view, label: 'Friends'),
    _PSNavTab(icon: Icons.search, label: 'Search'),
  ];

  late final AnimationController _entryController;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    // Burgundy panels — distinct from the main app background.
    final iconBarColor = _iconBarColor;
    final titleStripColor = _titleStripColor;
    final activeColor = _activeAccent;

    final navHeight = _totalHeight + bottomInset;
    final hideOffset = navHeight + 16;
    final scrollHide = (1.0 - widget.visibility.clamp(0.0, 1.0)) * hideOffset;

    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) {
        final entryT = Curves.easeOutCubic.transform(_entryController.value);
        final entryOffset = (1.0 - entryT) * hideOffset;
        return Transform.translate(
          offset: Offset(0, entryOffset + scrollHide),
          child: Opacity(
            opacity: widget.visibility.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: SizedBox(
        height: navHeight,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Icon bar: full height to screen bottom, icons stay at top ─
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: _ShadowCurvedPanel(
                peakY: _iconBarPeakY,
                fillColor: iconBarColor,
                shadow: BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: _iconBarHeight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(_tabs.length, (i) {
                            return Expanded(
                              child: _BottomNavItem(
                                icon: _tabs[i].icon,
                                isActive: i == widget.selectedIndex,
                                marginBottom: _iconMarginBottom[i],
                                primaryColor: activeColor,
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  widget.onTabChanged(i);
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            // ── Title strip: same position, layered on bottom of icon bar ─
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: _labelStripHeight + bottomInset,
              child: _ShadowCurvedPanel(
                peakY: _labelPeakY,
                fillColor: titleStripColor,
                shadow: BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: SizedBox(
                    height: _labelStripHeight,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, anim) =>
                            FadeTransition(opacity: anim, child: child),
                        child: Text(
                          _tabs[widget.selectedIndex].label,
                          key: ValueKey(widget.selectedIndex),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ── Active indicator + upward magenta glow (tangent-aligned) ────
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomInset,
              height: _labelStripHeight + _activeGlowReach,
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _ActiveSeamPainter(
                    activeIndex: widget.selectedIndex,
                    tabCount: _tabs.length,
                    stripHeight: _labelStripHeight,
                    peakY: _labelPeakY,
                    color: activeColor,
                    barWidth: _capsuleWidth,
                    barHeight: _capsuleHeight,
                    glowReach: _activeGlowReach,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Curved panel with an upward shadow so it reads as a separate floating layer.
class _ShadowCurvedPanel extends StatelessWidget {
  const _ShadowCurvedPanel({
    required this.peakY,
    required this.fillColor,
    required this.shadow,
    required this.child,
  });

  final double peakY;
  final Color fillColor;
  final BoxShadow shadow;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(boxShadow: [shadow]),
      child: _CurvedPanel(
        peakY: peakY,
        fillColor: fillColor,
        child: child,
      ),
    );
  }
}

/// A single curved-top panel: clips + paints the arched background.
class _CurvedPanel extends StatelessWidget {
  const _CurvedPanel({
    required this.peakY,
    required this.fillColor,
    required this.child,
  });

  final double peakY;
  final Color fillColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PSCurvedTopClipper(peakY: peakY),
      child: CustomPaint(
        painter: PSCurvedTopPainter(
          peakY: peakY,
          fillColor: fillColor,
        ),
        child: child,
      ),
    );
  }
}

/// One tab in the icon bar: animated glow on the active icon. The active
/// underline capsule is drawn separately so it can sit on the title-bar curve.
class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.isActive,
    required this.marginBottom,
    required this.primaryColor,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final double marginBottom;
  final Color primaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeIconColor = Color.lerp(primaryColor, Colors.white, 0.25)!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: marginBottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Active icon — no downward glow (keeps area below title bar clean).
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: Icon(
                icon,
                size: 26,
                color: isActive
                    ? activeIconColor
                    : Colors.white.withValues(alpha: 0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveSeamPainter extends CustomPainter {
  const _ActiveSeamPainter({
    required this.activeIndex,
    required this.tabCount,
    required this.stripHeight,
    required this.peakY,
    required this.color,
    required this.barWidth,
    required this.barHeight,
    required this.glowReach,
  });

  final int activeIndex;
  final int tabCount;
  final double stripHeight;
  final double peakY;
  final Color color;
  final double barWidth;
  final double barHeight;
  final double glowReach;

  @override
  void paint(Canvas canvas, Size size) {
    final t = (activeIndex + 0.5) / tabCount;
    final (centerX, curveY, angle) = _curvedTopTangent(
      Size(size.width, stripHeight),
      peakY,
      t,
    );
    // Use actual curve Y at this tab — center tabs sit higher on the arch.
    final edgeY = size.height - stripHeight + curveY;

    canvas.save();
    canvas.translate(centerX, edgeY - barHeight / 2);
    canvas.rotate(angle);

    _paintUpwardGlow(canvas);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: barWidth,
          height: barHeight,
        ),
        const Radius.circular(1.5),
      ),
      Paint()..color = color,
    );
    canvas.restore();
  }

  /// Soft magenta bloom spreading upward from the active line (PS reference).
  void _paintUpwardGlow(Canvas canvas) {
    const layers = [
      (alpha: 0.10, blur: 26.0, widthExtra: 28.0, height: 56.0, offsetY: -30.0),
      (alpha: 0.18, blur: 16.0, widthExtra: 16.0, height: 36.0, offsetY: -20.0),
      (alpha: 0.32, blur: 9.0, widthExtra: 8.0, height: 20.0, offsetY: -12.0),
    ];

    for (final layer in layers) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(0, layer.offsetY),
            width: barWidth + layer.widthExtra,
            height: layer.height,
          ),
          Radius.circular(layer.height / 2),
        ),
        Paint()
          ..color = color.withValues(alpha: layer.alpha)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, layer.blur),
      );
    }
  }

  @override
  bool shouldRepaint(_ActiveSeamPainter oldDelegate) =>
      oldDelegate.activeIndex != activeIndex ||
      oldDelegate.tabCount != tabCount ||
      oldDelegate.stripHeight != stripHeight ||
      oldDelegate.peakY != peakY ||
      oldDelegate.color != color ||
      oldDelegate.barWidth != barWidth ||
      oldDelegate.barHeight != barHeight ||
      oldDelegate.glowReach != glowReach;
}

/// Point on the curved top edge and its tangent angle at param [t] (0…1).
(double, double, double) _curvedTopTangent(Size size, double peakY, double t) {
  final w = size.width;
  final p0y = peakY;
  final p1x = w / 2;
  final p1y = 0.0;
  final p2x = w;
  final p2y = peakY;

  final omt = 1 - t;
  final x = omt * omt * 0 + 2 * omt * t * p1x + t * t * p2x;
  final y = omt * omt * p0y + 2 * omt * t * p1y + t * t * p2y;

  final dx = 2 * omt * (p1x - 0) + 2 * t * (p2x - p1x);
  final dy = 2 * omt * (p1y - p0y) + 2 * t * (p2y - p1y);
  final angle = math.atan2(dy, dx);

  return (x, y, angle);
}

class _PSNavTab {
  const _PSNavTab({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Height of [PSStyleBottomNav] including safe area.
double psBottomNavHeight(BuildContext context) {
  const iconBarHeight = 70.0;
  const labelStripHeight = 56.0;
  const overlap = 12.0;
  return iconBarHeight + labelStripHeight - overlap +
      MediaQuery.paddingOf(context).bottom;
}
