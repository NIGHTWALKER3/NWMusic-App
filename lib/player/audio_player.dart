import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AppAudioPlayer {
  static final AudioPlayer _player = AudioPlayer();

  static List<Map<String, dynamic>> _playlist = [];
  static int _currentIndex = -1;

  static Map<String, dynamic>? currentSong;

  static AudioPlayer get player => _player;

  /// Play song from list (SAFE VERSION)
  static Future<void> playFromList(
    List<Map<String, dynamic>> songs,
    int index,
  ) async {
    if (songs.isEmpty || index < 0 || index >= songs.length) return;

    final song = songs[index];

    // 🔑 Try all possible audio keys
    final audioUrl =
        song['audio'] ??
        song['url'] ??
        song['audio_url'] ??
        song['preview_url'];

    // ❌ Stop if audio URL is invalid
    if (audioUrl == null ||
        audioUrl.toString().isEmpty ||
        !audioUrl.toString().startsWith('http')) {
      print('❌ Invalid audio URL: $song');
      return;
    }

    _playlist = songs;
    _currentIndex = index;
    currentSong = song;

    final imageUrl =
        song['image'] ??
        song['album_image'] ??
        song['cover'] ??
        '';

    try {
      await _player.stop();

      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(audioUrl),
          tag: MediaItem(
            id: audioUrl,
            title: song['name'] ?? song['title'] ?? 'Unknown Song',
            artist:
                song['artist_name'] ?? song['artist'] ?? 'Unknown Artist',
            artUri: imageUrl.isNotEmpty ? Uri.parse(imageUrl) : null,
          ),
        ),
      );

      await _player.play();
    } catch (e) {
      print('❌ Audio error: $e');
    }
  }

  /// Play / Pause
  static void togglePlayPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  /// Next
  static Future<void> playNext() async {
    if (_currentIndex + 1 >= _playlist.length) return;
    await playFromList(_playlist, _currentIndex + 1);
  }

  /// Previous
  static Future<void> playPrevious() async {
    if (_currentIndex - 1 < 0) return;
    await playFromList(_playlist, _currentIndex - 1);
  }

  /// Stop
  static Future<void> stop() async {
    await _player.stop();
    currentSong = null;
    _currentIndex = -1;
    _playlist = [];
  }
}
