import 'package:flutter/material.dart';
import '../services/music_provider.dart';
import '../player/audio_player.dart';
import '../widgets/mini_player.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> songs = [];
  final TextEditingController controller = TextEditingController();

  Future<void> search() async {
    if (controller.text.isEmpty) return;
    final data = await MusicProvider.search(controller.text);
    setState(() => songs = List<Map<String, dynamic>>.from(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Music"),
      ),

      // 👇 BODY + MINI PLAYER FLOATING
      body: Stack(
        children: [
          Column(
            children: [
              // 🔎 SEARCH FIELD
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Song or artist",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: search,
                    ),
                  ),
                  onSubmitted: (_) => search(),
                ),
              ),
            ],
          ),

          // 🎵 SONG LIST
          Padding(
            padding: const EdgeInsets.only(top: 70, bottom: 90), // space for search & player
            child: ListView.builder(
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
          ),

          // 🎧 MINI PLAYER FLOATING ABOVE BOTTOM
          const Positioned(
            left: 0,
            right: 0,
            bottom: 10, // small margin
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}
