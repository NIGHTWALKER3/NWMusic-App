import 'package:flutter/material.dart';
import '../services/music_provider.dart';
import '../player/audio_player.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List songs = [];
  final TextEditingController controller = TextEditingController();

  void search() async {
    if (controller.text.isEmpty) return;
    final data = await MusicProvider.search(controller.text);
    setState(() => songs = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Music")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Song or artist",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: search,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  title: Text(song['name']),
                  subtitle: Text(song['artist_name']),
                  onTap: () {
                    AppAudioPlayer.play(song['audio']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

