import 'package:flutter/material.dart';

/// Exposes scroll-driven bar visibility (0 = hidden, 1 = fully visible) to
/// descendants such as the home app bar.
class ScrollBarsScope extends InheritedWidget {
  const ScrollBarsScope({
    super.key,
    required this.visibility,
    required super.child,
  });

  final double visibility;

  static double of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<ScrollBarsScope>()
            ?.visibility ??
        1.0;
  }

  @override
  bool updateShouldNotify(ScrollBarsScope oldWidget) =>
      oldWidget.visibility != visibility;
}
