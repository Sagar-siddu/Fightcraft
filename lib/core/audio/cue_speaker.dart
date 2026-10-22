import 'package:flutter_tts/flutter_tts.dart';

/// Thin wrapper around flutter_tts (PRD 8.1).
///
/// - A new cue always cancels whatever is still being spoken (no overlap).
/// - [stop] invalidates any speak() call still in flight, so a cue that was
///   requested just before pause/end can never be spoken afterwards.
/// - TTS failures never throw into the workout: they are reported through
///   [onError] and the caller keeps the timer running and the cue on screen.
class CueSpeaker {
  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  int _generation = 0;

  /// Called with a short description whenever TTS init or speech fails.
  void Function(String message)? onError;

  Future<void> init() async {
    if (_ready) return;
    try {
      _tts.setErrorHandler((msg) => onError?.call('$msg'));
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.55);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      // Wait for completion so stop()/speak() ordering is deterministic.
      await _tts.awaitSpeakCompletion(true);
      _ready = true;
    } catch (e) {
      onError?.call('TTS init failed: $e');
    }
  }

  Future<void> speak(String text) async {
    final gen = ++_generation;
    try {
      await init();
      if (!_ready) return;
      await _tts.stop(); // cancel stale speech first
      if (gen != _generation) return; // stop() or a newer cue arrived meanwhile
      await _tts.speak(text);
    } catch (e) {
      onError?.call('TTS speak failed: $e');
    }
  }

  /// Highest priority (PRD 8.2): stop speech and cancel anything in flight.
  Future<void> stop() async {
    _generation++;
    try {
      await _tts.stop();
    } catch (e) {
      onError?.call('TTS stop failed: $e');
    }
  }
}
