import 'package:flutter/material.dart';
import 'package:sutra_mobile/src/core/theme/theme_provider.dart';
import 'package:sutra_mobile/src/features/home/presentation/screens/home_landing_screen.dart';
import 'package:sutra_mobile/src/shared/widgets/sutra_nav_bar.dart';

void main() => runApp(const SandboxApp());

class SandboxApp extends StatelessWidget {
  const SandboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sutra UI Sandbox',
      debugShowCheckedModeBanner: false,
      theme: buildSutraTheme(),
      home: const _SandboxShell(),
    );
  }
}

/// SANDBOX-ONLY shell. Mirrors the real `MainShellScreen` (nav bar + body) but
/// without GoRouter/feature-flags. Only the Home tab has content; the other
/// tabs are out of scope and just switch the highlighted nav item.
///
/// NOT for paste-back — the real app has its own routed shell. The thing to
/// redesign here is [SutraNavBar], not this shell.
class _SandboxShell extends StatefulWidget {
  const _SandboxShell();

  @override
  State<_SandboxShell> createState() => _SandboxShellState();
}

class _SandboxShellState extends State<_SandboxShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // body renders behind the glass nav bar
      body: _index == 0
          ? const StitchHomeLandingScreen()
          : const _OutOfScopeTab(),
      bottomNavigationBar: SutraNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _OutOfScopeTab extends StatelessWidget {
  const _OutOfScopeTab();

  @override
  Widget build(BuildContext context) {
    final colors = context.sutraColors;
    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Text(
          'This tab is out of scope for the redesign.',
          style: TextStyle(color: colors.onSurfaceSecondary),
        ),
      ),
    );
  }
}
