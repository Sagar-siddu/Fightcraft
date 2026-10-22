import 'package:vibration/vibration.dart';

/// Short, distinguishable haptic patterns (PRD 8.3). Haptics are supplementary
/// and can be switched off; the P1 settings screen will drive [enabled].
///
/// Uses the vibrator directly instead of Flutter's HapticFeedback: on Android
/// that goes through "touch feedback", which many phones disable or make too
/// weak to feel, so it can silently do nothing.
class Haptics {
  bool enabled = true;

  /// Whether this phone reports a vibrator. Logged by the spike screen.
  Future<bool> isAvailable() async => (await Vibration.hasVibrator()) == true;

  /// Two firm buzzes: round starts. Pattern is [wait, buzz, wait, buzz] in ms.
  Future<void> roundStart() => _play([0, 250, 120, 250]);

  /// Three buzzes: round ends.
  Future<void> roundEnd() => _play([0, 250, 120, 250, 120, 250]);

  Future<void> _play(List<int> pattern) async {
    if (!enabled) return;
    try {
      if (await isAvailable()) {
        await Vibration.vibrate(pattern: pattern);
      }
    } catch (_) {
      // Haptics are supplementary; never let them affect the workout.
    }
  }
}
