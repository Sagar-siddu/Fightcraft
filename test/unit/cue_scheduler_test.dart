import 'package:flutter_test/flutter_test.dart';
import 'package:fightcraft/core/audio/cue_scheduler.dart';

void main() {
  group('CueScheduler', () {
    test('fires nothing before the first cue time', () {
      final s = CueScheduler(
        interval: const Duration(seconds: 6),
        firstCueAt: const Duration(seconds: 6),
      );
      expect(s.pollDue(const Duration(seconds: 5)), isNull);
    });

    test('fires on time and advances', () {
      final s = CueScheduler(interval: const Duration(seconds: 6));
      expect(s.pollDue(Duration.zero), Duration.zero);
      expect(s.pollDue(const Duration(seconds: 5)), isNull);
      expect(s.pollDue(const Duration(seconds: 6)), Duration.zero);
      expect(s.firedCount, 2);
    });

    test('skips missed cues instead of replaying a backlog', () {
      final s = CueScheduler(interval: const Duration(seconds: 6));
      s.pollDue(Duration.zero); // cue 0
      // Process frozen for ~20s: cues at 6, 12, 18 are stale.
      final late = s.pollDue(const Duration(seconds: 20));
      expect(late, isNotNull);
      expect(s.nextDueAt, const Duration(seconds: 24));
      expect(s.pollDue(const Duration(seconds: 21)), isNull);
    });

    test('reset starts the sequence over', () {
      final s = CueScheduler(interval: const Duration(seconds: 6));
      s.pollDue(const Duration(seconds: 7));
      s.reset();
      expect(s.firedCount, 0);
      expect(s.nextDueAt, Duration.zero);
    });
  });
}
