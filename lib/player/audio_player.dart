import 'package:just_audio/just_audio.dart';

class AppAudioPlayer {
  static final AudioPlayer _player = AudioPlayer();

  // Current playlist
  static List<Map<String, dynamic>> _playlist = [];
  static int _currentIndex = -1;

  // Currently playing song info
  static Map<String, dynamic>? currentSong;

  // Expose player to UI
  static AudioPlayer get player => _player;

  /// Play a song from a list (used for next / prev)
  static Future<void> playFromList(
    List<Map<String, dynamic>> songs,
    int index,
  ) async {
    if (songs.isEmpty || index < 0 || index >= songs.length) return;

    _playlist = songs;
    _currentIndex = index;
    currentSong = songs[index];

    final url = currentSong!['audio'];
    await _player.setUrl(url);
    _player.play();
  }

  /// Play / Pause toggle
  static void togglePlayPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  /// Play next song
  static Future<void> playNext() async {
    if (_currentIndex + 1 >= _playlist.length) return;
    await playFromList(_playlist, _currentIndex + 1);
  }

  /// Play previous song
  static Future<void> playPrevious() async {
    if (_currentIndex - 1 < 0) return;
    await playFromList(_playlist, _currentIndex - 1);
  }

  /// Stop player
  static Future<void> stop() async {
    await _player.stop();
    currentSong = null;
    _currentIndex = -1;
    _playlist = [];
  }
}
