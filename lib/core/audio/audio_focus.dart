import 'dart:async';

import 'package:audio_session/audio_session.dart';

/// Audio focus and route-change handling (PRD 8.4, Phase 0 deliverable).
///
/// For the spike this only *reports* events (focus lost/regained, headphones
/// unplugged, device list changes) so you can see what Android does during
/// calls and headset changes. The timer is deliberately not paused here: PRD
/// 13 says to preserve timer correctness and apply a documented policy. The
/// policy gets decided from what the test matrix shows.
class AudioFocus {
  StreamSubscription<AudioInterruptionEvent>? _interruptions;
  StreamSubscription<void>? _noisy;
  StreamSubscription<AudioDevicesChangedEvent>? _devices;

  /// Returns whether focus was granted.
  Future<bool> request({required void Function(String event) onEvent}) async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    await _cancelSubscriptions();
    _interruptions = session.interruptionEventStream.listen((e) {
      onEvent('audio focus ${e.begin ? "LOST" : "regained"} (${e.type.name})');
    });
    _noisy = session.becomingNoisyEventStream.listen((_) {
      onEvent('headphones unplugged / output became noisy');
    });
    _devices = session.devicesChangedEventStream.listen((e) {
      onEvent(
        'audio devices changed: +${e.devicesAdded.length} -${e.devicesRemoved.length}',
      );
    });

    return session.setActive(true);
  }

  Future<void> release() async {
    await _cancelSubscriptions();
    final session = await AudioSession.instance;
    await session.setActive(false);
  }

  Future<void> _cancelSubscriptions() async {
    await _interruptions?.cancel();
    await _noisy?.cancel();
    await _devices?.cancel();
    _interruptions = null;
    _noisy = null;
    _devices = null;
  }
}
