import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';
import 'api_interface.dart';

class ArchiveService implements MusicApiInterface {
  @override
  Future<List<Song>> searchSongs(String query) async {
    final url =
        'https://archive.org/advancedsearch.php'
        '?q=$query AND mediatype:audio'
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
        source: 'Archive',
      );
    }).toList();
  }
}

