import 'package:flutter/material.dart';
import '../player/audio_player.dart';
import '../screens/full_player_screen.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  void initState() {
    super.initState();

    // Rebuild mini player when audio state changes
    AppAudioPlayer.player.playerStateStream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final song = AppAudioPlayer.currentSong;

    // Hide mini player if nothing is playing
    if (song == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const FullPlayerScreen(),
          ),
        );
      },
      child: Container(
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
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  song['image'] ?? song['album_image'] ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade800,
                    child:
                        const Icon(Icons.music_note, color: Colors.white),
                  ),
                ),
              ),
            ),

            // 🎶 SONG INFO
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song['name'] ?? 'Unknown Song',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    song['artist_name'] ?? 'Unknown Artist',
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
      ),
    );
  }
}
