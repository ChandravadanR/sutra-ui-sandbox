import 'package:flutter/material.dart';
import 'package:sutra_mobile/src/core/theme/theme_provider.dart';
import 'package:sutra_mobile/src/sandbox/placeholder_strip.dart';
import 'package:sutra_mobile/src/shared/widgets/ps_slide_down_sheet.dart';

/// ▶▶ DEVELOPER: THIS IS ONE OF THE 3 FILES TO REDESIGN. ◀◀
///
/// Trimmed sandbox copy of the real home landing screen.
class StitchHomeLandingScreen extends StatelessWidget {
  const StitchHomeLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.sutraColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: ListView(
        padding: EdgeInsets.only(
          top: psSheetPeekHeight(context) + 8,
          bottom: 160,
        ),
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
          SizedBox(height: 24),
          PlaceholderStrip(label: 'Recommended for you'),
          SizedBox(height: 24),
          PlaceholderStrip(label: 'Live sessions'),
        ],
      ),
    );
  }
}
