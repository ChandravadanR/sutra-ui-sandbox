import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sutra_mobile/src/shared/widgets/ps_compact_nav_geometry.dart';
import 'package:sutra_mobile/src/shared/widgets/ps_sheet_controller.dart';

/// Social sheet content (Friends / Chats) inside [PSSlideDownSheet].
class FriendsSheetScreen extends StatefulWidget {
  const FriendsSheetScreen({
    super.key,
    this.sheetController,
    this.activeTab = PSCompactTab.friends,
    this.compactReveal = 0,
  });

  final PSSheetController? sheetController;
  final PSCompactTab activeTab;
  final double compactReveal;

  @override
  State<FriendsSheetScreen> createState() => _FriendsSheetScreenState();
}

class _FriendsSheetScreenState extends State<FriendsSheetScreen> {
  static const _sheetBackground = Color(0xFF1A0B10);
  static const _badgeGreen = Color(0xFF1DB954);

  int _segment = 0;

  static const _friends = [
    _FriendData(
      name: 'Stanislas_Biliby',
      status: 'Warhammer 40,000: Space Marine 2',
      online: true,
      psPlus: true,
      playing: true,
      avatarColors: [Color(0xFF5C4033), Color(0xFF8B6914)],
    ),
    _FriendData(
      name: 'Amol Wani',
      status: 'Last online 6 days ago',
      online: false,
      avatarColors: [Color(0xFF2D4A6E), Color(0xFF1A3050)],
    ),
    _FriendData(
      name: 'Chandravadan Raut',
      status: 'Last online 2 weeks ago',
      online: false,
      psPlus: true,
      avatarColors: [Color(0xFF4A3728), Color(0xFF6B4F3A)],
    ),
    _FriendData(
      name: 'Alex Chen',
      status: 'Last online 1 month ago',
      online: false,
      avatarColors: [Color(0xFF3D5A4A), Color(0xFF2A4035)],
    ),
    _FriendData(
      name: 'Jordan Lee',
      status: 'Last online 3 months ago',
      online: false,
      avatarColors: [Color(0xFF4A3D5C), Color(0xFF352A45)],
    ),
    _FriendData(
      name: 'Priya Sharma',
      status: 'Last online 4 months ago',
      online: false,
      psPlus: true,
      avatarColors: [Color(0xFF5C3D4A), Color(0xFF402830)],
    ),
  ];

  static const _chats = [
    _ChatData(
      name: 'Nirbhey Singh Pahwa',
      preview: 'Chandravadan Raut sent a sticker.',
      date: '11/16',
      avatarColors: [Color(0xFF3A5A7A), Color(0xFF254060)],
    ),
    _ChatData(
      name: 'badgirlx62',
      preview: 'Chandravadan Raut sent an image.',
      date: '8/18',
      avatarColors: [Color(0xFF5A3A6A), Color(0xFF402850)],
    ),
    _ChatData(
      name: 'Amol Wani',
      preview: 'Okay ✌️',
      date: '8/18',
      avatarColors: [Color(0xFF2D4A6E), Color(0xFF1A3050)],
    ),
    _ChatData(
      name: 'sammy_Galactic29',
      preview: 'Did you just defend my base?',
      date: '8/18',
      avatarColors: [Color(0xFF4A5040), Color(0xFF303828)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = widget.sheetController;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomPad = widget.compactReveal > 0.35
        ? PSCompactNavGeometry.contentBottomInset(bottomInset)
        : 20.0;

    Widget body(double topPadding) {
      if (widget.activeTab == PSCompactTab.chat) {
        return _ChatsView(
          topPadding: topPadding,
          bottomPadding: bottomPad,
          chats: _chats,
        );
      }
      return _FriendsView(
        topPadding: topPadding,
        bottomPadding: bottomPad,
        segment: _segment,
        friends: _friends,
        onSegmentChanged: (i) => setState(() => _segment = i),
      );
    }

    if (controller == null) {
      return ColoredBox(
        color: _sheetBackground,
        child: body(MediaQuery.paddingOf(context).top + 8),
      );
    }

    return ColoredBox(
      color: _sheetBackground,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final collapseT =
              ((controller.progress - 0.88) / 0.12).clamp(0.0, 1.0);
          final topInset = MediaQuery.paddingOf(context).top;
          final topPadding =
              12.0 * (1.0 - collapseT) + (topInset + 8) * collapseT;
          return body(topPadding);
        },
      ),
    );
  }
}

class _FriendsView extends StatelessWidget {
  const _FriendsView({
    required this.topPadding,
    required this.bottomPadding,
    required this.segment,
    required this.friends,
    required this.onSegmentChanged,
  });

  final double topPadding;
  final double bottomPadding;
  final int segment;
  final List<_FriendData> friends;
  final ValueChanged<int> onSegmentChanged;

  static const _accentMagenta = Color(0xFFE8196A);

  @override
  Widget build(BuildContext context) {
    final online = friends.where((f) => f.online).toList();
    final offline = friends.where((f) => !f.online).toList();

    return ListView(
      padding: EdgeInsets.fromLTRB(20, topPadding, 20, bottomPadding),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Friends',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1.1,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            _AddFriendButton(
              color: _accentMagenta,
              onTap: () => HapticFeedback.selectionClick(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _SegmentToggle(
          selected: segment,
          onChanged: onSegmentChanged,
        ),
        const SizedBox(height: 24),
        if (segment == 0) ...[
          _SectionLabel('Online (${online.length})'),
          const SizedBox(height: 12),
          for (final f in online) _FriendRow(friend: f),
          const SizedBox(height: 20),
          _SectionLabel('Offline'),
          const SizedBox(height: 12),
          for (final f in offline) _FriendRow(friend: f),
        ] else
          Padding(
            padding: const EdgeInsets.only(top: 64),
            child: Center(
              child: Text(
                'No pending requests',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 15,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ChatsView extends StatelessWidget {
  const _ChatsView({
    required this.topPadding,
    required this.bottomPadding,
    required this.chats,
  });

  final double topPadding;
  final double bottomPadding;
  final List<_ChatData> chats;

  static const _accentMagenta = Color(0xFFE8196A);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20, topPadding, 20, bottomPadding),
      children: [
        Row(
          children: [
            const Text(
              'Chats',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1.1,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            _CircleActionButton(
              color: _accentMagenta,
              icon: Icons.help_outline_rounded,
              onTap: () => HapticFeedback.selectionClick(),
            ),
            const SizedBox(width: 10),
            _CircleActionButton(
              color: _accentMagenta,
              icon: Icons.edit_outlined,
              onTap: () => HapticFeedback.selectionClick(),
            ),
          ],
        ),
        const SizedBox(height: 24),
        for (final chat in chats) _ChatRow(chat: chat),
      ],
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({required this.chat});

  final _ChatData chat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FriendAvatar(colors: chat.avatarColors),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  chat.preview,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            chat.date,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatData {
  const _ChatData({
    required this.name,
    required this.preview,
    required this.date,
    required this.avatarColors,
  });

  final String name;
  final String preview;
  final String date;
  final List<Color> avatarColors;
}

class _AddFriendButton extends StatelessWidget {
  const _AddFriendButton({required this.color, required this.onTap});

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: const Icon(
          Icons.person_add_alt_1_rounded,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SegmentToggle extends StatelessWidget {
  const _SegmentToggle({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  static const _trackColor = Color(0xFF2A121C);
  static const _activePill = Color(0xFF4A2435);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _trackColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          _SegmentPill(
            label: 'All',
            count: 11,
            active: selected == 0,
            activeColor: _activePill,
            onTap: () => onChanged(0),
          ),
          _SegmentPill(
            label: 'Requests',
            count: 0,
            active: selected == 1,
            activeColor: _activePill,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _SegmentPill extends StatelessWidget {
  const _SegmentPill({
    required this.label,
    required this.count,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: active ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: active
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.55),
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _FriendsSheetScreenState._badgeGreen,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1,
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.45),
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _FriendRow extends StatelessWidget {
  const _FriendRow({required this.friend});

  final _FriendData friend;

  static const _badgeGreen = Color(0xFF1DB954);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _FriendAvatar(colors: friend.avatarColors),
              if (friend.online)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _badgeGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1A0B10),
                        width: 2,
                      ),
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
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        friend.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (friend.psPlus) ...[
                      const SizedBox(width: 6),
                      const _PsPlusBadge(),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (friend.playing)
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.sports_esports_outlined,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        friend.status,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 13,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendAvatar extends StatelessWidget {
  const _FriendAvatar({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Icon(
        Icons.person,
        size: 28,
        color: Colors.white.withValues(alpha: 0.35),
      ),
    );
  }
}

class _PsPlusBadge extends StatelessWidget {
  const _PsPlusBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFD60A),
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Text(
        '+',
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _FriendData {
  const _FriendData({
    required this.name,
    required this.status,
    required this.online,
    required this.avatarColors,
    this.psPlus = false,
    this.playing = false,
  });

  final String name;
  final String status;
  final bool online;
  final bool psPlus;
  final bool playing;
  final List<Color> avatarColors;
}
