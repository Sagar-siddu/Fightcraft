/// Pure-Dart round clock. The monotonic [Stopwatch] is the single source of
/// truth for elapsed time; UI/periodic ticks only *read* it (PRD 11.4, FR-006).
///
/// No Flutter imports, so this moves unchanged into the Phase 1 workout engine
/// and can be unit-tested without a phone.
class RoundClock {
  RoundClock({required this.roundLength, Stopwatch? stopwatch})
      : _sw = stopwatch ?? Stopwatch();

  final Duration roundLength;
  final Stopwatch _sw;

  bool get isRunning => _sw.isRunning;

  Duration get elapsed => _sw.elapsed;

  Duration get remaining {
    final r = roundLength - _sw.elapsed;
    return r.isNegative ? Duration.zero : r;
  }

  bool get isFinished => _sw.elapsed >= roundLength;

  void start() => _sw.start();
  void pause() => _sw.stop();
  void reset() => _sw.reset();
}
