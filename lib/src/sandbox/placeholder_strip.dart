import 'package:flutter/material.dart';
import 'package:sutra_mobile/src/core/theme/theme_provider.dart';

/// SANDBOX-ONLY placeholder.
///
/// Stands in for the real home content strips (Profile brief, Continue learning,
/// Trending courses/teachers, Hot topics, Upcoming sessions). Those are out of
/// scope for this redesign, so they are shown as labelled grey boxes instead of
/// shipping the real (backend-driven) widgets.
class PlaceholderStrip extends StatelessWidget {
  const PlaceholderStrip({
    super.key,
    required this.label,
    this.height = 120,
  });

  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.sutraColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.outlineVariant),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.widgets_outlined, color: colors.onSurfaceSecondary),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: colors.onSurfaceSecondary, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              '(placeholder — out of scope)',
              style: TextStyle(
                color: colors.onSurfaceSecondary.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
