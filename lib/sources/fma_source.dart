import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';
import 'music_source.dart';

class FmaSource implements MusicSource {
  @override
  String get sourceName => 'FMA';

  @override
  Future<List<Song>> search(String query) async {
    final url =
        'https://archive.org/advancedsearch.php'
        '?q=collection:freemusicarchive AND $query'
        '&fl[]=identifier&fl[]=title&fl[]=creator'
        '&rows=20&page=1&output=json';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return [];

    final data = json.decode(response.body);
    final docs = data['response']['docs'] as List;

    return docs.map((item) {
      final id = item['identifier'];
      return Song(
        id: id,
        title: item['title'] ?? 'Unknown',
        artist: item['creator'] ?? 'Unknown',
        streamUrl: 'https://archive.org/download/$id/$id.mp3',
        source: sourceName,
      );
    }).toList();
  }
}

