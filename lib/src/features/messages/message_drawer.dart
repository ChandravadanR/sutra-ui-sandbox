import 'package:flutter/material.dart';
import 'package:sutra_mobile/src/core/theme/theme_provider.dart';
import 'package:sutra_mobile/src/sandbox/mock_chats.dart';

/// ▶▶ DEVELOPER: THIS IS THE NEW COMPONENT TO BUILD/REDESIGN. ◀◀
///
/// Top pull-down drawer that replaces the old message icon → chat-list page.
/// It slides DOWN from the top and holds the **Personal / Business** tabs with
/// the message lists. The actual conversation/messaging window is unchanged and
/// out of scope — tapping a row here just shows a snackbar in the sandbox.
///
/// This file is a minimal, working starting point so the sandbox runs end-to-end.
/// Redesign freely: the pull-down mechanism (drag-to-open instead of a tap),
/// the tab styling, the row layout, etc.
class MessageDrawer {
  /// Opens the pull-down drawer. Triggered from the home app bar.
  static Future<void> show(BuildContext context) {
    return showGeneralDialog<void>(
      context: context,
      barrierLabel: 'Messages',
      barrierDismissible: true,
      barrierColor: context.sutraColors.scrim,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const _MessageDrawerPanel(),
      transitionBuilder: (context, anim, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
  }
}

class _MessageDrawerPanel extends StatelessWidget {
  const _MessageDrawerPanel();

  @override
  Widget build(BuildContext context) {
    final colors = context.sutraColors;
    final typo = context.sutraTypography;
    final media = MediaQuery.of(context);

    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: media.size.height * 0.82,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(28),
            ),
            border: Border.all(color: colors.glassBorderColor),
          ),
          child: SafeArea(
            bottom: false,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                    child: Row(
                      children: [
                        Text(
                          'Messages',
                          style: TextStyle(
                            fontSize: typo.heading2Size,
                            fontWeight: typo.heading2Weight,
                            color: colors.onSurface,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close, color: colors.onSurface),
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    labelColor: colors.primary,
                    unselectedLabelColor: colors.onSurfaceSecondary,
                    indicatorColor: colors.primary,
                    tabs: const [
                      Tab(text: 'Personal'),
                      Tab(text: 'Business'),
                    ],
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        _ChatList(chats: personalChats),
                        _ChatList(chats: businessChats),
                      ],
                    ),
                  ),
                  // Grab handle at the bottom edge (pull-down affordance).
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
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

class _ChatList extends StatelessWidget {
  const _ChatList({required this.chats});
  final List<MockChat> chats;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: chats.length,
      itemBuilder: (context, i) => _ChatRow(chat: chats[i]),
    );
  }
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({required this.chat});
  final MockChat chat;

  @override
  Widget build(BuildContext context) {
    final colors = context.sutraColors;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colors.secondaryContainer,
        child: Icon(
          chat.isGroup ? Icons.groups_outlined : Icons.person_outline,
          color: colors.onSecondaryContainer,
        ),
      ),
      title: Row(
        children: [
          if (chat.pinned)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(Icons.push_pin, size: 14, color: colors.onSurfaceSecondary),
            ),
          Expanded(
            child: Text(
              chat.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colors.onSurface, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: colors.onSurfaceSecondary),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chat.time,
            style: TextStyle(color: colors.onSurfaceSecondary, fontSize: 11),
          ),
          const SizedBox(height: 4),
          if (chat.unread > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${chat.unread}',
                style: TextStyle(
                  color: colors.onPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        // Messaging window is unchanged / out of scope for this sandbox.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Open chat with ${chat.name} (out of scope)')),
        );
      },
    );
  }
}
