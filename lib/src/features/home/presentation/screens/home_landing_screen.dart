import 'package:flutter/material.dart';
import 'package:sutra_mobile/src/core/theme/theme_provider.dart';
import 'package:sutra_mobile/src/features/messages/message_drawer.dart';
import 'package:sutra_mobile/src/sandbox/placeholder_strip.dart';
import 'package:sutra_mobile/src/shared/widgets/liquid_glass_container.dart';

/// ▶▶ DEVELOPER: THIS IS ONE OF THE 3 FILES TO REDESIGN. ◀◀
///
/// Trimmed sandbox copy of the real home landing screen. The six content strips
/// are replaced with [PlaceholderStrip]s (out of scope), and all Riverpod /
/// backend providers are removed.
///
/// The redesign task: the **message icon** in the app bar (below) currently
/// opens the new pull-down [MessageDrawer]. Rework how that entry point looks /
/// is triggered as part of the new bottom-nav + drawer design.
class StitchHomeLandingScreen extends StatelessWidget {
  const StitchHomeLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.sutraColors;
    final typo = context.sutraTypography;

    return Scaffold(
      backgroundColor: colors.background,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: LiquidGlassContainer(
          borderRadius: BorderRadius.zero,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Sutra',
                    style: TextStyle(
                      fontSize: typo.heading1Size,
                      fontWeight: typo.heading1Weight,
                      color: colors.primary,
                    ),
                  ),
                  const Spacer(),
                  Badge.count(
                    count: 3, // (was businessUnreadCountProvider)
                    isLabelVisible: true,
                    child: IconButton(
                      onPressed: () => _todo(context, 'Notifications'),
                      icon: Icon(
                        Icons.notifications_outlined,
                        size: 24,
                        color: colors.onSurface,
                      ),
                      tooltip: 'Notifications',
                    ),
                  ),
                  // ▼ THE MESSAGE ENTRY POINT — opens the new pull-down drawer.
                  IconButton(
                    onPressed: () => MessageDrawer.show(context),
                    icon: Icon(
                      Icons.chat_bubble_outline,
                      size: 24,
                      color: colors.onSurface,
                    ),
                    tooltip: 'Messages',
                  ),
                  IconButton(
                    onPressed: () => _todo(context, 'Settings'),
                    icon: Icon(
                      Icons.settings_outlined,
                      size: 24,
                      color: colors.onSurface,
                    ),
                    tooltip: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 100, bottom: 120),
        children: const [
          PlaceholderStrip(label: 'Profile brief header', height: 96),
          SizedBox(height: 24),
          PlaceholderStrip(label: 'Continue learning'),
          SizedBox(height: 24),
          PlaceholderStrip(label: 'Trending courses'),
          SizedBox(height: 24),
          PlaceholderStrip(label: 'Trending teachers'),
          SizedBox(height: 24),
          PlaceholderStrip(label: 'Hot topics', height: 64),
          SizedBox(height: 24),
          PlaceholderStrip(label: 'Upcoming sessions'),
        ],
      ),
    );
  }

  void _todo(BuildContext context, String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$what (out of scope)')),
    );
  }
}
