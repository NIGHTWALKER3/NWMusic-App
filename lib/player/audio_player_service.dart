import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance =
      AudioPlayerService._internal();

  factory AudioPlayerService() => _instance;

  AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();
  Song? currentSong;

  Stream<PlayerState> get playerState => _player.playerStateStream;
  bool get isPlaying => _player.playing;

  Future<void> playSong(Song song) async {
    currentSong = song;
    await _player.setUrl(song.url);
    _player.play();
  }

  void togglePlayPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }
}

final audioService = AudioPlayerService();

