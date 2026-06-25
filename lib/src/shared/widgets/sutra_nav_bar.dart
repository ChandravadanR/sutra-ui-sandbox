import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sutra_mobile/src/core/theme/theme_provider.dart';

/// 4-tab Liquid Glass curved bottom navigation bar.
/// Shape: 28px rounded top corners (PS5-style curved bar).
/// Active tab: radial spotlight glow from bottom + visible label + scaled icon.
///
/// ▶▶ DEVELOPER: THIS IS ONE OF THE 3 FILES TO REDESIGN. ◀◀
class SutraNavBar extends StatelessWidget {
  const SutraNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final ValueChanged<int> onTap;

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

  @override
  Widget build(BuildContext context) {
    final colors = context.sutraColors;
    final tabCount = _tabs.length;
    // Alignment.x for Align + FractionallySizedBox(widthFactor: 1/n):
    // places child's left edge at index * tabWidth, centering spotlight under each tab.
    final spotlightX = tabCount > 1
        ? 2.0 * currentIndex / (tabCount - 1) - 1.0
        : 0.0;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.82),
            border: Border(
              top: BorderSide(
                color: colors.glassBorderColor,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 68,
              child: Stack(
                children: [
                  // Animated spotlight beam — slides to active tab
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeInOut,
                    alignment: Alignment(spotlightX, 0),
                    child: FractionallySizedBox(
                      widthFactor: 1 / tabCount,
                      heightFactor: 1,
                      child: _SpotlightBeam(color: colors.primary),
                    ),
                  ),
                  // Tab items row on top of spotlight
                  Row(
                    children: List.generate(tabCount, (i) {
                      final isActive = i == currentIndex;
                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            onTap(i);
                          },
                          child: _NavTabItem(
                            tab: _tabs[i],
                            isActive: isActive,
                            activeColor: colors.primary,
                            inactiveColor: colors.onSurfaceSecondary,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpotlightBeam extends StatelessWidget {
  const _SpotlightBeam({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.bottomCenter,
          radius: 1.5,
          colors: [
            color.withValues(alpha: 0.50),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedScale(
          scale: isActive ? 1.15 : 1.0,
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
        const SizedBox(height: 4),
        // Label fades in/out; invisible state still occupies space for stable layout.
        AnimatedOpacity(
          opacity: isActive ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Text(
            tab.label,
            style: TextStyle(
              color: activeColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
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
