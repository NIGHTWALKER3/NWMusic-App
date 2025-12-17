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

  @override
  void initState() {
    super.initState();
    loadMusic();
  }

  Future<void> loadMusic() async {
    final data = await MusicProvider.search(""); // 🔥 fetch all sources
    setState(() => songs = List<Map<String, dynamic>>.from(data));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("All Music"),
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
            ListView.builder(
              padding: const EdgeInsets.only(bottom: 110),
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  title: Text(song['title'] ?? 'Unknown'),
                  subtitle: Text(song['artist'] ?? 'Unknown'),
                  trailing: Text(song['source'] ?? ''),
                  onTap: () {
                    AppAudioPlayer.playFromList(songs, index);
                  },
                );
              },
            ),
            const Positioned(
              left: 8,
              right: 8,
              bottom: 16,
              child: MiniPlayer(),
            ),
          ],
        ),
      ),
    );
  }
}
