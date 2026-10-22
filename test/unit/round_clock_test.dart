import 'package:flutter_test/flutter_test.dart';
import 'package:fightcraft/features/workout/round_clock.dart';

void main() {
  group('RoundClock', () {
    test('remaining never goes negative', () {
      final c = RoundClock(roundLength: Duration.zero);
      expect(c.remaining, Duration.zero);
      expect(c.isFinished, isTrue);
    });

    test('is not running until started, and pause stops it', () {
      final c = RoundClock(roundLength: const Duration(minutes: 3));
      expect(c.isRunning, isFalse);
      c.start();
      expect(c.isRunning, isTrue);
      c.pause();
      expect(c.isRunning, isFalse);
    });
  });
}
