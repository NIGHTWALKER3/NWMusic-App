import 'dart:convert';
import 'package:http/http.dart' as http;
import 'youtube_config.dart';

class YouTubeService {
  Future<List<Map<String, dynamic>>> searchMusic(String query) async {
    if (query.isEmpty) return [];

    final url =
        'https://www.googleapis.com/youtube/v3/search'
        '?part=snippet'
        '&type=video'
        '&maxResults=20'
        '&q=${Uri.encodeQueryComponent(query)}'
        '&key=${YouTubeConfig.apiKey}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return [];

    final data = json.decode(response.body);
    final items = data['items'] as List;

    return items.map((item) {
      final snippet = item['snippet'];
      return {
        'title': snippet['title'],
        'artist': snippet['channelTitle'],
        'videoId': item['id']['videoId'],
        'thumbnail': snippet['thumbnails']['high']['url'],
        'source': 'YouTube',
      };
    }).toList();
  }
}

