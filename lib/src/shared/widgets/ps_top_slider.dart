import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sutra_mobile/src/core/theme/theme_provider.dart';
import 'package:sutra_mobile/src/features/messages/message_drawer.dart';
import 'package:sutra_mobile/src/shared/widgets/ps_compact_bottom_nav.dart';

/// PlayStation App–style draggable top window slider.
///
/// Drag down from the top header. When fully expanded (reached the bottom),
/// [onExtentChanged] reports ~1.0 so the shell can swap to [PSCompactBottomNav].
class PSTopSlider extends StatefulWidget {
  const PSTopSlider({
    super.key,
    required this.compactNavHeight,
    required this.onExtentChanged,
    this.visibility = 1.0,
  });

  final double compactNavHeight;
  final ValueChanged<double> onExtentChanged;
  final double visibility;

  @override
  State<PSTopSlider> createState() => PSTopSliderState();
}

class PSTopSliderState extends State<PSTopSlider>
    with SingleTickerProviderStateMixin {
  static const Color _panelColor = Color(0xFF121018);
  static const double _curveDepth = 14;
  static const double _headerRowHeight = 48;
  static const double _handleHeight = 10;

  late final AnimationController _extentController;

  @override
  void initState() {
    super.initState();
    _extentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..addListener(_notifyExtent);
  }

  @override
  void dispose() {
    _extentController.removeListener(_notifyExtent);
    _extentController.dispose();
    super.dispose();
  }

  void _notifyExtent() => widget.onExtentChanged(_extentController.value);

  /// Collapse back to the top — called from [PSCompactBottomNav] chevron.
  void collapse() => _snapTo(0);

  double _collapsedHeight(double topInset) =>
      topInset + _headerRowHeight + _handleHeight + _curveDepth;

  double _expandedHeight(double screenHeight) =>
      (screenHeight - widget.compactNavHeight).clamp(0, screenHeight);

  void _snapTo(double target) {
    _extentController.animateTo(
      target.clamp(0.0, 1.0),
      curve: Curves.easeOutCubic,
    );
  }

  void _applyDragDelta(double deltaDy) {
    final topInset = MediaQuery.paddingOf(context).top;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final collapsed = _collapsedHeight(topInset);
    final expanded = _expandedHeight(screenHeight);
    final range = expanded - collapsed;
    if (range <= 0) return;
    _extentController.value =
        (_extentController.value - deltaDy / range).clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails details) {
    final v = details.primaryVelocity ?? 0;
    if (v > 400) {
      _snapTo(0);
    } else if (v < -400) {
      _snapTo(1);
    } else {
      _snapTo(_extentController.value > 0.45 ? 1.0 : 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final collapsed = _collapsedHeight(topInset);
    final expanded = _expandedHeight(screenHeight);

    final hideOffset = collapsed + 12;
    final scrollHide = (1.0 - widget.visibility.clamp(0.0, 1.0)) * -hideOffset;

    return AnimatedBuilder(
      animation: _extentController,
      builder: (context, _) {
        final extent = _extentController.value;
        final panelHeight = collapsed + (expanded - collapsed) * extent;

        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: Offset(0, scrollHide),
            child: Opacity(
              opacity: widget.visibility.clamp(0.0, 1.0),
              child: Material(
                color: Colors.transparent,
                elevation: 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragStart: (_) {},
                  onVerticalDragUpdate: (d) => _applyDragDelta(d.delta.dy),
                  onVerticalDragEnd: _onDragEnd,
                  child: SizedBox(
                    height: panelHeight,
                    child: Column(
                      children: [
                        if (extent < 0.92)
                          _TopSliderHeader(
                            topInset: topInset,
                            fadeOut: extent,
                            onChat: () => MessageDrawer.show(context),
                          ),
                        if (extent > 0.001)
                          Expanded(
                            child: ColoredBox(
                              color: _panelColor,
                              child: _FriendsPanelContent(
                                extent: extent,
                                scrollEnabled: extent >= 0.85,
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
        );
      },
    );
  }
}

class _TopSliderHeader extends StatelessWidget {
  const _TopSliderHeader({
    required this.topInset,
    required this.fadeOut,
    required this.onChat,
  });

  final double topInset;

  /// 0 = fully visible collapsed header, 1 = hidden (Friends screen).
  final double fadeOut;
  final VoidCallback onChat;

  static const Color _headerColor = Color(0xFF2E0B16);
  static const double _curveDepth = 14;

  @override
  Widget build(BuildContext context) {
    final headerHeight =
        topInset +
        PSTopSliderState._headerRowHeight +
        PSTopSliderState._handleHeight +
        _curveDepth;

    final headerOpacity = (1.0 - fadeOut * 1.4).clamp(0.0, 1.0);

    return Opacity(
      opacity: headerOpacity,
      child: SizedBox(
        height: headerHeight,
        width: double.infinity,
        child: ClipPath(
          clipper: _CurvedBottomClipper(curveDepth: _curveDepth),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: _headerColor,
              boxShadow: [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: topInset),
                SizedBox(
                  height: PSTopSliderState._headerRowHeight,
                  child: Row(
                    children: [
                      _HeaderIconButton(
                        icon: Icons.chat_bubble_outline,
                        onTap: onChat,
                      ),
                      Expanded(
                        child: Center(
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white.withValues(alpha: 0.85),
                            size: 28,
                          ),
                        ),
                      ),
                      const _HeaderIconPlaceholder(badgeCount: 1),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Visual-only slot — no tap; panel opens by dragging down only.
class _HeaderIconPlaceholder extends StatelessWidget {
  const _HeaderIconPlaceholder({this.badgeCount});

  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.sutraColors;
    Widget icon = Icon(
      Icons.people_outline,
      color: Colors.white.withValues(alpha: 0.85),
      size: 24,
    );
    if (badgeCount != null) {
      icon = Badge(
        label: Text('$badgeCount'),
        backgroundColor: colors.success,
        child: icon,
      );
    }
    return SizedBox(width: 64, child: Center(child: icon));
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 48,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Center(
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
}

class _FriendsPanelContent extends StatelessWidget {
  const _FriendsPanelContent({
    required this.extent,
    required this.scrollEnabled,
  });

  final double extent;
  final bool scrollEnabled;

  static const _friends = [
    ('Stanislas_Biliby', 'Warhammer 40,000: Space Marine 2', true),
    ('Amol Wani', 'Last online 6 days ago', false),
    ('Chandravadan Raut', 'Last online 2 weeks ago', false),
    ('Alex Chen', 'Last online 1 month ago', false),
    ('Jordan Lee', 'Last online 3 months ago', false),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.sutraColors;

    return Opacity(
      opacity: ((extent - 0.15) / 0.85).clamp(0.0, 1.0),
      child: ListView(
        physics: scrollEnabled
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          20,
          MediaQuery.paddingOf(context).top + 8,
          20,
          24,
        ),
        children: [
          Row(
            children: [
              Text(
                'Friends',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.mail_outline, color: colors.onError, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _FilterPill(colors: colors),
          const SizedBox(height: 20),
          Text(
            'Online (1)',
            style: TextStyle(color: colors.onSurfaceSecondary, fontSize: 13),
          ),
          const SizedBox(height: 8),
          for (final f in _friends.where((f) => f.$3))
            _FriendRow(name: f.$1, status: f.$2, online: true, colors: colors),
          const SizedBox(height: 16),
          Text(
            'Offline',
            style: TextStyle(color: colors.onSurfaceSecondary, fontSize: 13),
          ),
          const SizedBox(height: 8),
          for (final f in _friends.where((f) => !f.$3))
            _FriendRow(name: f.$1, status: f.$2, online: false, colors: colors),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.colors});

  final SutraColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('All', style: TextStyle(color: colors.onSurface)),
                  const SizedBox(width: 6),
                  _CountBadge(count: 11, colors: colors),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Requests',
                  style: TextStyle(color: colors.onSurfaceSecondary),
                ),
                const SizedBox(width: 6),
                _CountBadge(count: 0, colors: colors),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.colors});

  final int count;
  final SutraColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors.success,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FriendRow extends StatelessWidget {
  const _FriendRow({
    required this.name,
    required this.status,
    required this.online,
    required this.colors,
  });

  final String name;
  final String status;
  final bool online;
  final SutraColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colors.secondaryContainer,
                child: Icon(Icons.person, color: colors.onSecondaryContainer),
              ),
              if (online)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.background, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: TextStyle(
                    color: colors.onSurfaceSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CurvedBottomClipper extends CustomClipper<Path> {
  const _CurvedBottomClipper({required this.curveDepth});

  final double curveDepth;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(0, 0)
      ..lineTo(0, h - curveDepth)
      ..quadraticBezierTo(w / 2, h, w, h - curveDepth)
      ..lineTo(w, 0)
      ..close();
  }

  @override
  bool shouldReclip(_CurvedBottomClipper oldClipper) =>
      oldClipper.curveDepth != curveDepth;
}

