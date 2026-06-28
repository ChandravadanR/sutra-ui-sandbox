import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sutra_mobile/src/core/theme/theme_provider.dart';

/// Full-width bottom navigation bar with a convex curved top edge (PS5-style).
///
/// Active tab gets a radial glow + underline; label sits beneath the icon row.
/// Slides up on entry and hides on scroll-down.
///
/// ▶▶ DEVELOPER: THIS IS ONE OF THE 3 FILES TO REDESIGN. ◀◀
class SutraNavBar extends StatefulWidget {
  const SutraNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.visibility = 1.0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  /// 0 = fully hidden off-screen, 1 = fully visible.
  final double visibility;

  @override
  State<SutraNavBar> createState() => _SutraNavBarState();
}

class _SutraNavBarState extends State<SutraNavBar>
    with SingleTickerProviderStateMixin {
  // Subtle top-edge wave amplitude (keeps the bar ~uniform height L→R).
  static const _topCurve = 16.0;
  // Rounded "dialer" gap carved into the bottom-center edge.
  static const _notchHalfWidth = 30.0;
  static const _notchDepth = 16.0;
  static const _iconArea = 46.0;
  static const _labelArea = 16.0;

  static const _tabs = [
    _NavTab(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    _NavTab(
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront,
      label: 'Store',
    ),
    _NavTab(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      label: 'Explore',
    ),
    _NavTab(
      icon: Icons.donut_large_outlined,
      activeIcon: Icons.donut_large,
      label: 'Status',
    ),
    _NavTab(icon: Icons.call_outlined, activeIcon: Icons.call, label: 'Calls'),
    _NavTab(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  late final AnimationController _entryController;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.sutraColors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final tabCount = _tabs.length;
    final spotlightX = tabCount > 1
        ? 2.0 * widget.currentIndex / (tabCount - 1) - 1.0
        : 0.0;

    // Reserve enough space at the bottom so the carved notch never clips the
    // label, even on devices with no gesture inset.
    final reservedBottom =
        bottomInset > _notchDepth + 6 ? bottomInset : _notchDepth + 6;
    final totalHeight = _topCurve + _iconArea + _labelArea + reservedBottom;
    final hideOffset = totalHeight + 16;
    final scrollHide = (1.0 - widget.visibility.clamp(0.0, 1.0)) * hideOffset;

    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, _) {
        final entryT = Curves.easeOutCubic.transform(_entryController.value);
        final entryOffset = (1.0 - entryT) * hideOffset;

        return Transform.translate(
          offset: Offset(0, entryOffset + scrollHide),
          child: Opacity(
            opacity: widget.visibility.clamp(0.0, 1.0),
            child: SizedBox(
              width: double.infinity,
              height: totalHeight,
              child: ClipPath(
                clipper: const _CurvedNavClipper(
                  topCurve: _topCurve,
                  notchHalfWidth: _notchHalfWidth,
                  notchDepth: _notchDepth,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: colors.glassBlurRadius,
                    sigmaY: colors.glassBlurRadius,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surface
                          .withValues(alpha: colors.glassSurfaceOpacity + 0.25),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: _topCurve,
                        left: 4,
                        right: 4,
                        bottom: reservedBottom,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: _iconArea,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                AnimatedAlign(
                                  duration: const Duration(milliseconds: 280),
                                  curve: Curves.easeInOut,
                                  alignment: Alignment(spotlightX, 0),
                                  child: FractionallySizedBox(
                                    widthFactor: 1 / tabCount,
                                    heightFactor: 1,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                          center: Alignment.center,
                                          radius: 0.85,
                                          colors: [
                                            colors.primary
                                                .withValues(alpha: 0.28),
                                            colors.primary.withValues(alpha: 0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedAlign(
                                  duration: const Duration(milliseconds: 280),
                                  curve: Curves.easeInOut,
                                  alignment: Alignment(spotlightX, 1),
                                  child: FractionallySizedBox(
                                    widthFactor: 1 / tabCount,
                                    child: Container(
                                      height: 2.5,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: colors.primary,
                                        boxShadow: [
                                          BoxShadow(
                                            color: colors.primary
                                                .withValues(alpha: 0.75),
                                            blurRadius: 10,
                                            spreadRadius: 0.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: List.generate(tabCount, (i) {
                                    final isActive = i == widget.currentIndex;
                                    return Expanded(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          HapticFeedback.selectionClick();
                                          widget.onTap(i);
                                        },
                                        child: _NavTabItem(
                                          tab: _tabs[i],
                                          isActive: isActive,
                                          activeColor: colors.onSurface,
                                          inactiveColor:
                                              colors.onSurfaceSecondary,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: _labelArea,
                            width: double.infinity,
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeInOut,
                              alignment: Alignment(spotlightX, 0),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Text(
                                  _tabs[widget.currentIndex].label,
                                  key: ValueKey(widget.currentIndex),
                                  style: TextStyle(
                                    color: colors.onSurface,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Uniform-height bar: a gentle symmetric wave on the top edge (raised corners,
/// soft center) plus a rounded "dialer" notch carved into the bottom-center.
class _CurvedNavClipper extends CustomClipper<Path> {
  const _CurvedNavClipper({
    required this.topCurve,
    required this.notchHalfWidth,
    required this.notchDepth,
  });

  final double topCurve;
  final double notchHalfWidth;
  final double notchDepth;

  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final c = topCurve;

    // Top edge — corners highest (y=0), shallow valleys, small center rise.
    path.moveTo(0, h);
    path.lineTo(0, 0);
    path.cubicTo(w * 0.10, 0, w * 0.15, c, w * 0.27, c);
    path.cubicTo(w * 0.38, c, w * 0.43, c * 0.45, cx, c * 0.45);
    path.cubicTo(w * 0.57, c * 0.45, w * 0.62, c, w * 0.73, c);
    path.cubicTo(w * 0.85, c, w * 0.90, 0, w, 0);

    // Right edge down to bottom.
    path.lineTo(w, h);

    // Bottom edge (right → left) with a rounded notch at the center.
    path.lineTo(cx + notchHalfWidth, h);
    path.cubicTo(
      cx + notchHalfWidth * 0.55,
      h,
      cx + notchHalfWidth * 0.55,
      h - notchDepth,
      cx,
      h - notchDepth,
    );
    path.cubicTo(
      cx - notchHalfWidth * 0.55,
      h - notchDepth,
      cx - notchHalfWidth * 0.55,
      h,
      cx - notchHalfWidth,
      h,
    );
    path.lineTo(0, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_CurvedNavClipper oldClipper) =>
      oldClipper.topCurve != topCurve ||
      oldClipper.notchHalfWidth != notchHalfWidth ||
      oldClipper.notchDepth != notchDepth;
}

class _NavTabItem extends StatelessWidget {
  const _NavTabItem({
    required this.tab,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
  });

  final _NavTab tab;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedScale(
        scale: isActive ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: Icon(
            isActive ? tab.activeIcon : tab.icon,
            key: ValueKey(isActive),
            color: isActive ? activeColor : inactiveColor,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}
