import 'package:flutter/material.dart';
import '../widgets/mini_player.dart';
import '../player/audio_player.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Good Evening",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle("Recently Played"),
          _horizontalSongs(),
          const SizedBox(height: 24),

          _sectionTitle("Made For You"),
          _horizontalSongs(),
          const SizedBox(height: 24),

          _sectionTitle("Trending Now"),
          _horizontalSongs(),

          const SizedBox(height: 100), // space for mini player
        ],
      ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _horizontalSongs() {
    // TEMP SAMPLE SONGS (replace with API later)
    final songs = [
      {
        "name": "Sample Song 1",
        "artist_name": "Unknown Artist",
        "url":
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        "image": null,
        "album_image": null,
      },
      {
        "name": "Sample Song 2",
        "artist_name": "Unknown Artist",
        "url":
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        "image": null,
        "album_image": null,
      },
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];

          return GestureDetector(
            onTap: () {
              // ✅ FIX: correct method
              AppAudioPlayer.playFromList(songs, index);
            },
            child: Container(
              width: 130,
              margin: const EdgeInsets.only(right: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 120,
                      color: Colors.grey.shade800,
                      child: const Center(
                        child: Icon(
                          Icons.play_arrow,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    song['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
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
          );
        },
      ),
    );
  }
}
