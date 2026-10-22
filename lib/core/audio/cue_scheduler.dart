/// Fixed-interval cue pacer for the spike. Decides when the next cue is due
/// from elapsed monotonic time, never from a tick count, so a delayed tick
/// cannot cause drift. Phase 3 grows this into the full audio scheduler
/// (priorities, execution windows, intensity-based spacing).
class CueScheduler {
  CueScheduler({required this.interval, this.firstCueAt = Duration.zero});

  final Duration interval;
  final Duration firstCueAt;
  int _fired = 0;

  int get firedCount => _fired;

  Duration get nextDueAt => firstCueAt + interval * _fired;

  /// If a cue is due, marks it fired and returns how late it is, else null.
  /// Cues missed entirely (process frozen for several intervals) are skipped,
  /// not replayed, so stale callouts never pile up (PRD 8.4, "transitions
  /// beat speech").
  Duration? pollDue(Duration elapsed) {
    if (elapsed < nextDueAt) return null;
    final late = elapsed - nextDueAt;
    final missed = late.inMilliseconds ~/ interval.inMilliseconds;
    _fired += 1 + missed;
    return late - interval * missed;
  }

  void reset() => _fired = 0;
}
