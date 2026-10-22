import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/audio/audio_focus.dart';
import '../../core/audio/cue_scheduler.dart';
import '../../core/audio/cue_speaker.dart';
import '../../core/platform/haptics.dart';
import '../../core/platform/keep_alive.dart';
import '../combinations/technique_catalogue.dart';
import 'round_clock.dart';

enum _Phase { idle, running, paused, done }

/// Throwaway Phase 0 screen. Goal: prove cues stay on time with the screen
/// locked, app backgrounded, headphones plugged/unplugged, incoming call, etc.
/// Replaced by the real workout screen in Phase 4.
class SpikeScreen extends StatefulWidget {
  const SpikeScreen({super.key});

  @override
  State<SpikeScreen> createState() => _SpikeScreenState();
}

class _SpikeScreenState extends State<SpikeScreen> {
  // Spike parameters: selectable round length, a cue every N seconds.
  static const _lengthOptions = [1, 3, 10, 15]; // minutes
  static const _intervalOptions = [4, 6, 8]; // seconds

  int _lengthMin = 3;
  int _intervalSec = 6;

  late RoundClock _clock = RoundClock(roundLength: Duration(minutes: _lengthMin));
  late CueScheduler _scheduler =
      CueScheduler(interval: Duration(seconds: _intervalSec));
  final CueSpeaker _speaker = CueSpeaker();
  final AudioFocus _focus = AudioFocus();
  final Haptics _haptics = Haptics();

  Timer? _ticker;
  _Phase _phase = _Phase.idle;
  int _cueIndex = 0;
  int _lastNotifBucket = -1;
  String _currentCallout = '';
  final List<String> _log = [];
  late Duration _remaining = Duration(minutes: _lengthMin);

  bool get _active => _phase == _Phase.running || _phase == _Phase.paused;

  @override
  void initState() {
    super.initState();
    _speaker.onError = (m) => _logEvent('TTS ERROR: $m');
    _speaker.init();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _speaker.stop();
    _focus.release();
    SessionKeepAlive.stop();
    super.dispose();
  }

  void _logEvent(String text) {
    _log.insert(0, '${_fmt(_clock.elapsed)}  $text');
    if (_log.length > 120) _log.removeLast();
    if (mounted) setState(() {});
  }

  Future<void> _start() async {
    if (_active) return;
    await SessionKeepAlive.start();
    final granted = await _focus.request(onEvent: _logEvent);

    // Fresh clock and scheduler from the chosen settings.
    _clock = RoundClock(roundLength: Duration(minutes: _lengthMin));
    _scheduler = CueScheduler(interval: Duration(seconds: _intervalSec));
    _cueIndex = 0;
    _lastNotifBucket = -1;
    _currentCallout = '';
    _remaining = _clock.roundLength;
    _log.clear();
    if (!granted) _logEvent('audio focus NOT granted');
    _logEvent(
      'vibrator available: ${await _haptics.isAvailable()} | '
      'round ${_lengthMin}m, cue every ${_intervalSec}s',
    );

    _phase = _Phase.running;
    _clock.start();
    _haptics.roundStart();
    _ticker?.cancel();
    // Tick often; the clock, not the tick count, decides what is due.
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) => _tick());
    if (mounted) setState(() {});
  }

  void _tick() {
    if (_phase != _Phase.running) return;
    final elapsed = _clock.elapsed;

    // Round transition wins over any pending callout (PRD 7.5, 13).
    if (_clock.isFinished) {
      _end(natural: true);
      return;
    }

    final late = _scheduler.pollDue(elapsed);
    if (late != null) {
      final combo = spikeCombinations[_cueIndex % spikeCombinations.length];
      _cueIndex++;
      // One source for speech and screen text, so direction can't diverge.
      final spoken = spikeCatalogue.spoken(combo.techniqueIds);
      _currentCallout = spikeCatalogue.display(combo.techniqueIds);
      _speaker.speak(spoken); // failures are reported via onError
      _logEvent('late ${late.inMilliseconds} ms  "$spoken"');
    }

    // UI + notification refresh only; never used for timing.
    final rem = _clock.remaining;
    final bucket = rem.inSeconds ~/ 5;
    if (bucket != _lastNotifBucket) {
      _lastNotifBucket = bucket;
      SessionKeepAlive.updateNotification('Remaining ${_fmt(rem)}');
    }
    if (mounted) setState(() => _remaining = rem);
  }

  /// [natural] true = the round ran out; false = the user pressed End.
  Future<void> _end({required bool natural}) async {
    if (!_active) return;
    _phase = _Phase.done;
    _ticker?.cancel();
    _clock.pause();
    _currentCallout = '';
    if (natural) _remaining = Duration.zero;
    if (mounted) setState(() {});

    await _speaker.stop(); // highest priority: kill speech and pending cues
    _haptics.roundEnd();
    if (natural) {
      _logEvent('round complete');
      await _speaker.speak('Round over');
    } else {
      _logEvent('ended early by user');
    }
    await _focus.release();
    await SessionKeepAlive.stop();
  }

  void _pauseResume() {
    if (_phase == _Phase.running) {
      _phase = _Phase.paused;
      _clock.pause();
      _speaker.stop(); // no new callouts; cancel the one in flight
      _currentCallout = '';
      _logEvent('paused');
    } else if (_phase == _Phase.paused) {
      // Clock was frozen, so no cue expired while paused; nothing to replay.
      _phase = _Phase.running;
      _clock.start();
      _logEvent('resumed');
    }
    if (mounted) setState(() {});
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Widget _optionRow<T>({
    required String label,
    required List<T> options,
    required T selected,
    required String Function(T) text,
    required void Function(T) onSelected,
  }) {
    return Row(
      children: [
        SizedBox(width: 64, child: Text(label)),
        Expanded(
          child: Wrap(
            spacing: 8,
            children: [
              for (final o in options)
                ChoiceChip(
                  label: Text(text(o)),
                  selected: o == selected,
                  onSelected: _active ? null : (_) => onSelected(o),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fightcraft: Phase 0 spike')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                _fmt(_remaining),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              if (_phase == _Phase.paused)
                Text('PAUSED', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              // Visual backup for the spoken cue (PRD 4.4, 12).
              SizedBox(
                height: 80,
                child: Center(
                  child: Text(
                    _currentCallout,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              _optionRow<int>(
                label: 'Round',
                options: _lengthOptions,
                selected: _lengthMin,
                text: (v) => '$v min',
                onSelected: (v) => setState(() {
                  _lengthMin = v;
                  if (!_active) _remaining = Duration(minutes: v);
                }),
              ),
              _optionRow<int>(
                label: 'Cue every',
                options: _intervalOptions,
                selected: _intervalSec,
                text: (v) => '$v s',
                onSelected: (v) => setState(() => _intervalSec = v),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: _active ? null : _start,
                    child: const Text('Start'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: _active ? _pauseResume : null,
                    child: Text(_phase == _Phase.paused ? 'Resume' : 'Pause'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: _active ? () => _end(natural: false) : null,
                    child: const Text('End'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Event log (elapsed, lateness, cue / audio events)'),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _log.length,
                  itemBuilder: (_, i) => Text(
                    _log[i],
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
