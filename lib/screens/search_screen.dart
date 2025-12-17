import 'package:flutter/material.dart';
import '../services/music_provider.dart';
import '../player/audio_player.dart';
import '../widgets/mini_player.dart';
import 'youtube_player_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> songs = [];
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;

  Future<void> search() async {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      songs.clear();
    });

    final data = await MusicProvider.search(controller.text.trim());

    setState(() {
      songs = List<Map<String, dynamic>>.from(data);
      isLoading = false;
    });
  }

  void playSong(BuildContext context, Map<String, dynamic> song, int index) {
    final source = song['source'];

    if (source == 'YouTube') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => YouTubePlayerScreen(
            videoId: song['videoId'],
            title: song['name'],
          ),
        ),
      );
    } else {
      AppAudioPlayer.playFromList(songs, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Music"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // 🔎 SEARCH BAR
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Search song / artist",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: search,
                    ),
                  ),
                  onSubmitted: (_) => search(),
                ),
              ),

              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),

              // 🎵 RESULTS
              Expanded(
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return ListTile(
                      leading: Icon(
                        song['source'] == 'YouTube'
                            ? Icons.play_circle_fill
                            : Icons.music_note,
                      ),
                      title: Text(song['name'] ?? 'Unknown'),
                      subtitle: Text(
                        "${song['artist_name'] ?? 'Unknown'} • ${song['source']}",
                      ),
                      onTap: () => playSong(context, song, index),
                    );
                  },
                ),
              ),
            ],
          ),

          // 🎧 MINI PLAYER (only for non-YouTube)
          const Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}
