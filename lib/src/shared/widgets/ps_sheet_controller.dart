import 'package:flutter/foundation.dart';

/// Controls open/close of [PSSlideDownSheet] from the shell or compact nav.
class PSSheetController extends ChangeNotifier {
  bool _isOpen = false;
  double _progress = 0;

  bool get isOpen => _isOpen;
  double get progress => _progress;

  VoidCallback? _open;
  VoidCallback? _close;

  void attach({
    required VoidCallback open,
    required VoidCallback close,
  }) {
    _open = open;
    _close = close;
  }

  void detach() {
    _open = null;
    _close = null;
  }

  void open() => _open?.call();

  void close() => _close?.call();

  void setProgress(double value) {
    final clamped = value.clamp(0.0, 1.0);
    if ((_progress - clamped).abs() < 0.001) return;
    _progress = clamped;
    final open = clamped > 0.5;
    if (_isOpen != open) _isOpen = open;
    notifyListeners();
  }

  void setOpen(bool value) => setProgress(value ? 1.0 : 0.0);
}
