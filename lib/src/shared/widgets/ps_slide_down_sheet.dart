import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:sutra_mobile/src/shared/widgets/ps_compact_nav_geometry.dart';
import 'package:sutra_mobile/src/shared/widgets/ps_sheet_controller.dart';
import 'package:sutra_mobile/src/shared/widgets/ps_sheet_peek_geometry.dart';

/// Full-screen overlay that slides down from the top (PS App style).
///
/// When collapsed, a burgundy **peek header** stays visible at the top so the
/// user can grab and drag down. When expanded, the sheet stops above
/// [bottomNavHeight] so the compact bottom nav remains visible.
class PSSlideDownSheet extends StatefulWidget {
  const PSSlideDownSheet({
    super.key,
    required this.controller,
    required this.background,
    required this.child,
    required this.bottomNavHeight,
    this.compactNav,
    this.compactActiveTab,
    this.activeCompactTab = PSCompactTab.chat,
    this.compactReveal = 0,
  });

  final PSSheetController controller;
  final Widget background;
  final Widget child;

  /// Height reserved for the bottom nav (compact when open).
  final double bottomNavHeight;

  /// Nav rail + icons.
  final Widget? compactNav;

  /// Sheet-colour active tab — part of the screen layer.
  final Widget? compactActiveTab;
  final PSCompactTab activeCompactTab;
  final double compactReveal;
  static const dragThresholdPx = 30.0;
  static const flingVelocity = 900.0;

  @override
  State<PSSlideDownSheet> createState() => _PSSlideDownSheetState();
}

class _PSSlideDownSheetState extends State<PSSlideDownSheet>
    with TickerProviderStateMixin {
  double _peekHeight(double topInset) => PSSheetPeekGeometry.totalHeight(topInset);

  late final AnimationController _progress;
  late final AnimationController _tabMorph;

  double _dragAccumulated = 0;
  bool _thresholdCrossed = false;

  double _sheetHeight(double screenHeight) {
    if (widget.compactReveal > 0.35) {
      return screenHeight;
    }
    return (screenHeight - widget.bottomNavHeight).clamp(0, screenHeight);
  }
  double _travelDistance(double screenHeight, double topInset) {
    final travel = _sheetHeight(screenHeight) - _peekHeight(topInset);
    return travel.clamp(1, screenHeight);
  }

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _tabMorph = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      value: PSCompactNavGeometry.tForTab(widget.activeCompactTab),
    );
    widget.controller.attach(open: _animateOpen, close: _animateClose);
    _progress.addListener(_syncProgress);
    _progress.addStatusListener(_onAnimStatus);
  }

  @override
  void didUpdateWidget(covariant PSSlideDownSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.detach();
      widget.controller.attach(open: _animateOpen, close: _animateClose);
    }
    if (oldWidget.activeCompactTab != widget.activeCompactTab) {
      _tabMorph.animateTo(
        PSCompactNavGeometry.tForTab(widget.activeCompactTab),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    widget.controller.detach();
    _progress.removeListener(_syncProgress);
    _progress.removeStatusListener(_onAnimStatus);
    _progress.dispose();
    _tabMorph.dispose();
    super.dispose();
  }

  void _syncProgress() => widget.controller.setProgress(_progress.value);

  void _onAnimStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.controller.setOpen(true);
    } else if (status == AnimationStatus.dismissed) {
      widget.controller.setOpen(false);
    }
  }

  void _animateOpen() => _runSpring(to: 1);
  void _animateClose() => _runSpring(to: 0);

  void _runSpring({required double to}) {
    _progress.animateWith(
      SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 400, damping: 32),
        _progress.value,
        to,
        0,
      ),
    );
  }

  void _resetDragTracking() {
    _dragAccumulated = 0;
    _thresholdCrossed = false;
  }

  void _applyDragDelta(double deltaDy, double travel) {
    _dragAccumulated += deltaDy;
    if (_dragAccumulated.abs() >= PSSlideDownSheet.dragThresholdPx) {
      _thresholdCrossed = true;
    }
    _progress.value = (_progress.value + deltaDy / travel).clamp(0.0, 1.0);
  }

  void _snapAfterDrag({required double velocity}) {
    final open = velocity > PSSlideDownSheet.flingVelocity
        ? true
        : velocity < -PSSlideDownSheet.flingVelocity
            ? false
            : _progress.value > 0.25 || _thresholdCrossed;
    _runSpring(to: open ? 1.0 : 0.0);
    _resetDragTracking();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final sheetH = _sheetHeight(screenHeight);
    final travel = _travelDistance(screenHeight, topInset);

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        widget.background,
        AnimatedBuilder(
          animation: _progress,
          builder: (context, child) {
            final peek = _peekHeight(topInset);
            final openHeight = sheetH;
            final currentHeight =
                peek + (openHeight - peek) * _progress.value;

            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: currentHeight,
              child: child!,
            );
          },
          child: ClipRRect(
            child: Material(
              color: const Color(0xFF1A0B10),
              elevation: 8,
              shadowColor: Colors.black54,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragStart: (_) => _resetDragTracking(),
                onVerticalDragUpdate: (d) =>
                    _applyDragDelta(d.delta.dy, travel),
                onVerticalDragEnd: (d) =>
                    _snapAfterDrag(velocity: d.primaryVelocity ?? 0),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _progress,
                      builder: (context, child) {
                        // Keep the peek header fully visible while dragging; only
                        // hand off to the Friends title near the fully-open state.
                        final collapseT = Curves.easeInOut.transform(
                          ((_progress.value - 0.88) / 0.12).clamp(0.0, 1.0),
                        );
                        return _SheetPeekHeader(
                          topInset: topInset,
                          collapseT: collapseT,
                        );
                      },
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final useCompactLayout =
                              widget.compactReveal > 0.35 &&
                                  widget.compactNav != null;

                          Widget content = widget.child;

                          if (!useCompactLayout) {
                            content = AnimatedBuilder(
                              animation: _progress,
                              builder: (context, child) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft:
                                        Radius.circular(28 * _progress.value),
                                    bottomRight:
                                        Radius.circular(28 * _progress.value),
                                  ),
                                  child: child,
                                );
                              },
                              child: content,
                            );
                            return content;
                          }

                          final bottomInset = MediaQuery.paddingOf(context).bottom;
                          final navH = PSCompactNavGeometry.totalHeight(bottomInset);
                          final bottomGap = PSCompactNavGeometry.contentNavGap;
                          final tabExt =
                              PSCompactNavGeometry.tabScreenExtension;

                          return Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            children: [
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                bottom: navH + bottomGap,
                                child: content,
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                height: bottomGap,
                                child: const ColoredBox(
                                  color: PSCompactNavGeometry.sheetGapColor,
                                ),
                              ),
                              if (widget.compactActiveTab != null)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: bottomGap,
                                  height: navH + tabExt,
                                  child: widget.compactActiveTab!,
                                ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: bottomGap,
                                child: Opacity(
                                  opacity:
                                      widget.compactReveal.clamp(0.0, 1.0),
                                  child: widget.compactNav,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Notched grab header — shoulders with chat/dice, center dip + pill handle.
class _SheetPeekHeader extends StatelessWidget {
  const _SheetPeekHeader({
    required this.topInset,
    this.collapseT = 0,
  });

  final double topInset;
  final double collapseT;

  static const Color _headerColor = Color(0xFF210F18);
  static const Color _badgeGreen = Color(0xFF1DB954);

  @override
  Widget build(BuildContext context) {
    final bodyHeight = PSSheetPeekGeometry.bodyHeight * (1.0 - collapseT);
    final height = collapseT >= 1 ? 0.0 : topInset + bodyHeight;
    final shoulderW =
        MediaQuery.sizeOf(context).width * PSSheetPeekGeometry.shoulderFraction;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipRect(
        child: Opacity(
          opacity: (1.0 - collapseT).clamp(0.0, 1.0),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _PeekHeaderPainter(color: _headerColor),
                ),
              ),
              Positioned(
                top: topInset,
                left: 0,
                right: 0,
                height: PSSheetPeekGeometry.iconRowHeight * (1.0 - collapseT),
                child: Row(
                  children: [
                    SizedBox(
                      width: shoulderW,
                      child: Center(
                        child: _PeekChatIcon(
                          color: Colors.white.withValues(alpha: 0.92),
                          size: 20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: shoulderW,
                      child: Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _PeekDiceIcon(
                              color: Colors.white.withValues(alpha: 0.92),
                              size: 20,
                            ),
                            Positioned(
                              right: shoulderW * 0.22,
                              bottom: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: _badgeGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  '1',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (collapseT < 0.95)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: PSSheetPeekGeometry.handleBottomMargin,
                  child: Opacity(
                    opacity: (1.0 - collapseT * 1.2).clamp(0.0, 1.0),
                    child: Center(
                      child: Container(
                        width: 120,
                        height: PSSheetPeekGeometry.handleHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.15),
                              Colors.white.withValues(alpha: 0.38),
                              Colors.white.withValues(alpha: 0.15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeekHeaderPainter extends CustomPainter {
  const _PeekHeaderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = PSSheetPeekGeometry.headerPath(size);
    canvas.drawShadow(path, Colors.black54, 4, false);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_PeekHeaderPainter old) => old.color != color;
}

class _PeekChatIcon extends StatelessWidget {
  const _PeekChatIcon({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.1,
      height: size,
      child: CustomPaint(painter: _PeekChatPainter(color: color)),
    );
  }
}

class _PeekChatPainter extends CustomPainter {
  const _PeekChatPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.22, 0, size.width * 0.58, size.height * 0.62),
        const Radius.circular(4),
      ),
      fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.22, size.width * 0.58, size.height * 0.62),
        const Radius.circular(4),
      ),
      fill,
    );
  }

  @override
  bool shouldRepaint(_PeekChatPainter old) => old.color != color;
}

class _PeekDiceIcon extends StatelessWidget {
  const _PeekDiceIcon({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.85,
      child: CustomPaint(painter: _PeekDicePainter(color: color)),
    );
  }
}

class _PeekDicePainter extends CustomPainter {
  const _PeekDicePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.28, 0, size.width * 0.62, size.height * 0.72),
        const Radius.circular(2.5),
      ),
      stroke,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.28, size.width * 0.62, size.height * 0.72),
        const Radius.circular(2.5),
      ),
      stroke,
    );
  }

  @override
  bool shouldRepaint(_PeekDicePainter old) => old.color != color;
}

/// Height of the collapsed peek header (for main-screen top padding).
double psSheetPeekHeight(BuildContext context) {
  return PSSheetPeekGeometry.totalHeight(MediaQuery.paddingOf(context).top);
}
