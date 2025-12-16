import 'package:flutter/material.dart';
import '../services/music_provider.dart';
import '../player/audio_player.dart';
import '../widgets/mini_player.dart';
import 'search_screen.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  List<Map<String, dynamic>> songs = [];
  String genre = "chill";

  @override
  void initState() {
    super.initState();
    loadMusic();
  }

  Future<void> loadMusic() async {
    final data = await MusicProvider.getByGenre(genre);
    setState(() => songs = List<Map<String, dynamic>>.from(data));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true, // 🔥 ensures above gesture buttons
      child: Scaffold(
        appBar: AppBar(
          title: Text("Genre: $genre"),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
            ),
          ],
        ),

        body: Stack(
          children: [
            // 🎵 SONG LIST
            ListView.builder(
              padding: const EdgeInsets.only(bottom: 110), // space for MiniPlayer
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  title: Text(song['name']),
                  subtitle: Text(song['artist_name']),
                  onTap: () {
                    AppAudioPlayer.playFromList(songs, index);
                  },
                );
              },
            ),

            // 🎧 MINI PLAYER (FLOATING, SAFE)
            const Positioned(
              left: 8,
              right: 8,
              bottom: 16, // 🔥 perfect Spotify-like spacing
              child: MiniPlayer(),
            ),
          ],
        ),
      ),
    );
  }
}
