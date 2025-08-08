import 'package:just_audio/just_audio.dart';

/// Service to handle alarm audio playback with ramp-up.
class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  /// Plays the sound at the given [assetPath] with a ramp-up over
  /// [rampSeconds]. The sound loops until [stop] is called.
  Future<void> play({required String assetPath, int rampSeconds = 0}) async {
    await _player.setLoopMode(LoopMode.one);
    await _player.setAsset(assetPath);
    if (rampSeconds > 0) {
      _player.setVolume(0.0);
      await _player.play();
      final step = 1.0 / rampSeconds;
      for (var i = 0; i < rampSeconds; i++) {
        await Future.delayed(const Duration(seconds: 1));
        final newVolume = (i + 1) * step;
        _player.setVolume(newVolume.clamp(0.0, 1.0));
      }
    } else {
      await _player.setVolume(1.0);
      await _player.play();
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }
}