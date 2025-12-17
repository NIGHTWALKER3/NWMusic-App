import 'package:just_audio/just_audio.dart';

class AppAudioPlayer {
  static final AudioPlayer _player = AudioPlayer();

  static Map<String, dynamic>? currentSong;

  static AudioPlayer get player => _player;

  /// Play a single song safely
  static Future<void> playSong(Map<String, dynamic> song) async {
    final audioUrl =
        song['audio'] ?? song['url'] ?? song['audio_url'] ?? song['preview_url'];

    if (audioUrl == null || audioUrl.toString().isEmpty || !audioUrl.toString().startsWith('http')) {
      print('❌ Invalid audio URL: $song');
      return;
    }

    currentSong = song;

    try {
      await _player.stop();
      await _player.setUrl(audioUrl);
      await _player.play();
    } catch (e) {
      print('❌ Audio error: $e');
    }
  }

  /// Play / Pause toggle
  static void togglePlayPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  /// Stop playback
  static Future<void> stop() async {
    await _player.stop();
    currentSong = null;
  }
}
