import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AppAudioPlayer {
  static final AudioPlayer _player = AudioPlayer();

  // Playlist
  static List<Map<String, dynamic>> _playlist = [];
  static int _currentIndex = -1;

  // Currently playing song
  static Map<String, dynamic>? currentSong;

  // Expose player
  static AudioPlayer get player => _player;

  /// Play song from list
  static Future<void> playFromList(
    List<Map<String, dynamic>> songs,
    int index,
  ) async {
    if (songs.isEmpty || index < 0 || index >= songs.length) return;

    _playlist = songs;
    _currentIndex = index;
    currentSong = songs[index];

    // ✅ FIX: support all common audio keys
    final audioUrl =
        currentSong!['audio'] ??
        currentSong!['url'] ??
        currentSong!['audio_url'];

    if (audioUrl == null || audioUrl.toString().isEmpty) return;

    final imageUrl =
        currentSong!['image'] ?? currentSong!['album_image'] ?? '';

    await _player.setAudioSource(
      AudioSource.uri(
        Uri.parse(audioUrl),
        tag: MediaItem(
          id: audioUrl,
          title: currentSong!['name'] ?? 'Unknown Song',
          artist: currentSong!['artist_name'] ?? 'Unknown Artist',
          artUri: imageUrl.isNotEmpty ? Uri.parse(imageUrl) : null,
        ),
      ),
    );

    _player.play();
  }

  /// Toggle play / pause
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

  /// Stop playback
  static Future<void> stop() async {
    await _player.stop();
    currentSong = null;
    _currentIndex = -1;
    _playlist = [];
  }
}
