import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_interface.dart';

class FmaService implements MusicAPI {
  @override
  Future<List<Map<String, dynamic>>> fetchByGenre(String genre) async {
    // FMA/Archive doesn't support genre search easily
    return [];
  }

  @override
  Future<List<Map<String, dynamic>>> searchMusic(String query) async {
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
      return {
        'id': id,
        'title': item['title'] ?? 'Unknown',
        'artist': item['creator'] ?? 'Unknown',
        'stream_url': 'https://archive.org/download/$id/$id.mp3',
        'source': 'FMA',
      };
    }).toList();
  }
}
