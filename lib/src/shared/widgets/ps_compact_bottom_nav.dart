import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sutra_mobile/src/shared/widgets/ps_compact_nav_geometry.dart';

/// Sheet-screen active tab — extends from content down over the nav slot.
class PSCompactActiveTabLayer extends StatefulWidget {
  const PSCompactActiveTabLayer({
    super.key,
    required this.activeTab,
    this.reveal = 1.0,
    this.morphT,
  });

  final PSCompactTab activeTab;
  final double reveal;
  final double? morphT;

  @override
  State<PSCompactActiveTabLayer> createState() =>
      _PSCompactActiveTabLayerState();
}

class _PSCompactActiveTabLayerState extends State<PSCompactActiveTabLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _morph;

  @override
  void initState() {
    super.initState();
    _morph = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
      value: widget.morphT ?? PSCompactNavGeometry.tForTab(widget.activeTab),
    );
  }

  @override
  void didUpdateWidget(PSCompactActiveTabLayer old) {
    super.didUpdateWidget(old);
    if (widget.morphT != null) {
      if ((old.morphT ?? _morph.value) != widget.morphT) {
        _morph.value = widget.morphT!;
      }
    } else if (old.activeTab != widget.activeTab) {
      _morph.animateTo(
        PSCompactNavGeometry.tForTab(widget.activeTab),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _morph.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final layerH = PSCompactNavGeometry.activeTabLayerHeight(bottomInset);

    return Opacity(
      opacity: widget.reveal.clamp(0.0, 1.0),
      child: AnimatedBuilder(
        animation: _morph,
        builder: (context, _) {
          final t = _morph.value;
          return LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final tabW = PSCompactNavGeometry.activeTabWidth(w);
              final tabLeft = PSCompactNavGeometry.activeTabLeft(w, t);

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: tabLeft,
                    bottom: bottomInset,
                    width: tabW,
                    height: layerH,
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: PSCompactActiveTabPainter(t: t),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// Compact nav rail + icons (active tab shape lives in [PSCompactActiveTabLayer]).
class PSCompactBottomNav extends StatefulWidget {
  const PSCompactBottomNav({
    super.key,
    required this.onChevronTap,
    required this.activeTab,
    required this.onTabChanged,
    this.visibility = 1.0,
    this.reveal = 1.0,
  });

  final VoidCallback onChevronTap;
  final PSCompactTab activeTab;
  final ValueChanged<PSCompactTab> onTabChanged;
  final double visibility;
  final double reveal;

  @override
  State<PSCompactBottomNav> createState() => _PSCompactBottomNavState();
}

class _PSCompactBottomNavState extends State<PSCompactBottomNav> {
  static const _iconBright = Color(0xFFFFFFFF);
  static const _iconDim = Color(0x99FFFFFF);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final totalH = PSCompactNavGeometry.totalHeight(bottomInset);
    final hideOffset = totalH + 8;
    final scrollHide = (1.0 - widget.visibility.clamp(0.0, 1.0)) * hideOffset;
    final slideUp = (1.0 - widget.reveal.clamp(0.0, 1.0)) * totalH;
    final chatActive = widget.activeTab == PSCompactTab.chat;

    return Transform.translate(
      offset: Offset(0, scrollHide + slideUp),
      child: Opacity(
        opacity: widget.visibility.clamp(0.0, 1.0) *
            widget.reveal.clamp(0.0, 1.0),
        child: SizedBox(
          height: totalH,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: totalH,
                child: CustomPaint(
                  painter: PSCompactNavBarPainter(bottomInset: bottomInset),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomInset,
                height: PSCompactNavGeometry.barHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _navItem(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          widget.onTabChanged(PSCompactTab.chat);
                        },
                        offsetY: chatActive ? -6 : 0,
                        child: _ChatBubblesIcon(
                          color: chatActive ? _iconBright : _iconDim,
                          size: 20,
                        ),
                      ),
                      _navItem(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          widget.onChevronTap();
                        },
                        offsetY: -(PSCompactNavGeometry.peakDepth + 6),
                        child: const Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: PSCompactNavGeometry.chevronMuted,
                          size: 28,
                        ),
                      ),
                      _navItem(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          widget.onTabChanged(PSCompactTab.friends);
                        },
                        offsetY: 2,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            _DiceIcon(
                              color: chatActive ? _iconDim : _iconBright,
                              size: 20,
                            ),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Container(
                                width: 16,
                                height: 16,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: PSCompactNavGeometry.badgeGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  '1',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required VoidCallback onTap,
    required Widget child,
    double offsetY = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Transform.translate(
        offset: Offset(0, offsetY),
        child: SizedBox(
          width: 52,
          height: 52,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _ChatBubblesIcon extends StatelessWidget {
  const _ChatBubblesIcon({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.12,
      height: size,
      child: CustomPaint(painter: _ChatBubblesPainter(color: color)),
    );
  }
}

class _ChatBubblesPainter extends CustomPainter {
  const _ChatBubblesPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.22,
          0,
          size.width * 0.58,
          size.height * 0.62,
        ),
        const Radius.circular(4),
      ),
      fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0,
          size.height * 0.22,
          size.width * 0.58,
          size.height * 0.62,
        ),
        const Radius.circular(4),
      ),
      fill,
    );
  }

  @override
  bool shouldRepaint(_ChatBubblesPainter old) => old.color != color;
}

class _DiceIcon extends StatelessWidget {
  const _DiceIcon({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.85,
      child: CustomPaint(painter: _DiceIconPainter(color: color)),
    );
  }
}

class _DiceIconPainter extends CustomPainter {
  const _DiceIconPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.28,
          0,
          size.width * 0.62,
          size.height * 0.72,
        ),
        const Radius.circular(3),
      ),
      stroke,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0,
          size.height * 0.28,
          size.width * 0.62,
          size.height * 0.72,
        ),
        const Radius.circular(3),
      ),
      stroke,
    );
  }

  @override
  bool shouldRepaint(_DiceIconPainter old) => old.color != color;
}

double psCompactBottomNavHeight(BuildContext context) {
  return PSCompactNavGeometry.totalHeight(
    MediaQuery.paddingOf(context).bottom,
  );
}
