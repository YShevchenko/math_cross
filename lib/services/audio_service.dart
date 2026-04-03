import 'package:audioplayers/audioplayers.dart';

/// Lightweight sound-effect player. Fails silently so audio issues
/// never crash the app.
class AudioService {
  final AudioPlayer _player = AudioPlayer();
  bool enabled = true;

  Future<void> playCorrect() => _play('correct.mp3');

  Future<void> playWrong() => _play('wrong.mp3');

  Future<void> playComplete() => _play('complete.mp3');

  Future<void> playHint() => _play('hint.mp3');

  Future<void> playTap() => _play('tap.mp3');

  Future<void> _play(String file) async {
    if (!enabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/$file'));
    } catch (_) {
      // Swallow errors -- sound must never break the app.
    }
  }

  void dispose() {
    _player.dispose();
  }
}
