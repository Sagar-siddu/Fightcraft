import 'package:flutter/services.dart';

/// Short, distinguishable haptic patterns (PRD 8.3). Haptics are supplementary
/// and can be switched off; the Phase P1 settings screen will drive [enabled].
class Haptics {
  bool enabled = true;

  /// Two firm pulses: round starts.
  Future<void> roundStart() async {
    if (!enabled) return;
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.heavyImpact();
  }

  /// Three pulses: round ends.
  Future<void> roundEnd() async {
    if (!enabled) return;
    for (var i = 0; i < 3; i++) {
      await HapticFeedback.heavyImpact();
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }
  }
}
