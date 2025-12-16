import 'package:flutter/material.dart';
import '../player/audio_player.dart';

class FullPlayerScreen extends StatefulWidget {
  const FullPlayerScreen({super.key});

  @override
  State<FullPlayerScreen> createState() => _FullPlayerScreenState();
}

class _FullPlayerScreenState extends State<FullPlayerScreen> {
  @override
  void initState() {
    super.initState();

    AppAudioPlayer.player.positionStream.listen((_) {
      if (mounted) setState(() {});
    });

    AppAudioPlayer.player.playerStateStream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final song = AppAudioPlayer.currentSong;

    if (song == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text("No song playing", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final position = AppAudioPlayer.player.position;
    final duration =
        AppAudioPlayer.player.duration ?? const Duration(seconds: 1);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 🎵 ALBUM IMAGE
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    song['image'] ?? song['album_image'] ?? '',
                    width: 280,
                    height: 280,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 280,
                      height: 280,
                      color: Colors.grey.shade800,
                      child: const Icon(
                        Icons.music_note,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🎶 SONG INFO
            Text(
              song['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              song['artist_name'],
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // ⏱ SEEK BAR
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds
                  .clamp(0, duration.inSeconds)
                  .toDouble(),
              onChanged: (value) {
                AppAudioPlayer.player
                    .seek(Duration(seconds: value.toInt()));
              },
            ),

            // ⏱ TIME
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _timeText(position),
                _timeText(duration),
              ],
            ),

            const SizedBox(height: 24),

            // ⏮ ⏯ ⏭ CONTROLS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 40,
                  icon:
                      const Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: AppAudioPlayer.playPrevious,
                ),
                const SizedBox(width: 20),
                IconButton(
                  iconSize: 60,
                  icon: Icon(
                    AppAudioPlayer.player.playing
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    color: Colors.white,
                  ),
                  onPressed: AppAudioPlayer.togglePlayPause,
                ),
                const SizedBox(width: 20),
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  onPressed: AppAudioPlayer.playNext,
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _timeText(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return Text(
      "$minutes:$seconds",
      style: const TextStyle(color: Colors.grey),
    );
  }
}

