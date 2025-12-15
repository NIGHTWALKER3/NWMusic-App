import 'package:flutter/material.dart';
import '../player/audio_player.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  void initState() {
    super.initState();

    // Listen to player state changes
    AppAudioPlayer.player.playerStateStream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final song = AppAudioPlayer.currentSong;

    // If no song is playing, show nothing
    if (song == null) return const SizedBox.shrink();

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        children: [
          // 🎵 SONG IMAGE
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              song['image'] ?? song['album_image'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),

          // 🎶 SONG INFO
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  song['artist_name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // ⏮ PREVIOUS
          IconButton(
            icon: const Icon(Icons.skip_previous, color: Colors.white),
            onPressed: AppAudioPlayer.playPrevious,
          ),

          // ⏯ PLAY / PAUSE
          IconButton(
            icon: Icon(
              AppAudioPlayer.player.playing
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: AppAudioPlayer.togglePlayPause,
          ),

          // ⏭ NEXT
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            onPressed: AppAudioPlayer.playNext,
          ),
        ],
      ),
    );
  }
}

