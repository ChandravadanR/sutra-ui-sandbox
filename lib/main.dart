import 'package:flutter/material.dart';
import 'package:sutra_mobile/src/core/theme/theme_provider.dart';
import 'package:sutra_mobile/src/features/friends/presentation/screens/friends_sheet_screen.dart';
import 'package:sutra_mobile/src/features/home/presentation/screens/home_landing_screen.dart';
import 'package:sutra_mobile/src/shared/widgets/ps_compact_bottom_nav.dart';
import 'package:sutra_mobile/src/shared/widgets/ps_compact_nav_geometry.dart';
import 'package:sutra_mobile/src/shared/widgets/ps_bottom_nav.dart';
import 'package:sutra_mobile/src/shared/widgets/ps_sheet_controller.dart';
import 'package:sutra_mobile/src/shared/widgets/ps_slide_down_sheet.dart';
import 'package:sutra_mobile/src/shared/widgets/scroll_bars_scope.dart';

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

class _SandboxShell extends StatefulWidget {
  const _SandboxShell();

  @override
  State<_SandboxShell> createState() => _SandboxShellState();
}

class _SandboxShellState extends State<_SandboxShell>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  PSCompactTab _compactTab = PSCompactTab.chat;
  late final AnimationController _barsController;
  late final PSSheetController _sheetController;

  static const _navSwapStart = 0.72;

  @override
  void initState() {
    super.initState();
    _barsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: 1.0,
    );
    _sheetController = PSSheetController();
    _sheetController.addListener(_onSheetProgress);
  }

  void _onSheetProgress() {
    if (_sheetController.progress > 0.05) {
      _showBars();
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetProgress);
    _barsController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  bool _onScroll(ScrollNotification notification) {
    if (_sheetController.progress > 0.05) return false;

    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      final offset = notification.metrics.pixels;

      if (delta > 1.5 && offset > 48) {
        _hideBars();
      } else if (delta < -1.5) {
        _showBars();
      }
    } else if (notification is ScrollEndNotification) {
      if (notification.metrics.pixels <= 0) {
        _showBars();
      }
    }
    return false;
  }

  void _hideBars() {
    if (_barsController.status != AnimationStatus.reverse &&
        _barsController.value > 0) {
      _barsController.reverse();
    }
  }

  void _showBars() {
    if (_barsController.status != AnimationStatus.forward &&
        _barsController.value < 1) {
      _barsController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainNavH = psBottomNavHeight(context);

    return AnimatedBuilder(
      animation: _barsController,
      builder: (context, _) {
        final visibility = Curves.easeOutCubic.transform(_barsController.value);

        return ListenableBuilder(
          listenable: _sheetController,
          builder: (context, _) {
            final progress = _sheetController.progress;
            final compactReveal = Curves.easeOutCubic.transform(
              ((progress - _navSwapStart) / (1.0 - _navSwapStart))
                  .clamp(0.0, 1.0),
            );
            final navVisibility = progress > 0.08 ? 1.0 : visibility;
            final compactNavInside = compactReveal > 0.35;
            // Main nav stays until compact nav moves inside the open sheet.
            final sheetBottomInset = compactNavInside ? 0.0 : mainNavH;
            final scaffoldBottomH = compactNavInside ? 0.0 : mainNavH;

            return Scaffold(
              extendBody: true,
              body: PSSlideDownSheet(
                controller: _sheetController,
                bottomNavHeight: sheetBottomInset,
                activeCompactTab: _compactTab,
                compactReveal: compactReveal,
                compactNav: PSCompactBottomNav(
                  activeTab: _compactTab,
                  visibility: navVisibility,
                  reveal: compactReveal,
                  onChevronTap: _sheetController.close,
                  onTabChanged: (tab) => setState(() => _compactTab = tab),
                ),
                compactActiveTab: PSCompactActiveTabLayer(
                  activeTab: _compactTab,
                  reveal: compactReveal,
                ),
                background: ScrollBarsScope(
                  visibility: visibility,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _onScroll,
                    child: _index == 0
                        ? const StitchHomeLandingScreen()
                        : const _OutOfScopeTab(),
                  ),
                ),
                child: FriendsSheetScreen(
                  sheetController: _sheetController,
                  activeTab: _compactTab,
                  compactReveal: compactReveal,
                ),
              ),
              bottomNavigationBar: scaffoldBottomH <= 0
                  ? null
                  : Material(
                      color: Colors.transparent,
                      elevation: 0,
                      child: SizedBox(
                        height: scaffoldBottomH,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          clipBehavior: Clip.none,
                          children: [
                            PSStyleBottomNav(
                              selectedIndex: _index,
                              visibility: navVisibility,
                              onTabChanged: (i) => setState(() => _index = i),
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}

class _OutOfScopeTab extends StatelessWidget {
  const _OutOfScopeTab();

  @override
  Widget build(BuildContext context) {
    final colors = context.sutraColors;
    return ListView(
      padding: EdgeInsets.fromLTRB(24, psSheetPeekHeight(context) + 8, 24, 160),
      children: [
        Center(
          child: Text(
            'This tab is out of scope for the redesign.',
            style: TextStyle(color: colors.onSurfaceSecondary),
          ),
        ),
        const SizedBox(height: 24),
        for (var i = 0; i < 12; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
      ],
    );
  }
}
