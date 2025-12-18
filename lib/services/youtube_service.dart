import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class YouTubeService {
  static int _currentKeyIndex = 0;

  // 🔐 10 API KEYS (FROM .env)
  static final List<String> _apiKeys = [
    dotenv.env['YT_KEY_1']!,
    dotenv.env['YT_KEY_2']!,
    dotenv.env['YT_KEY_3']!,
    dotenv.env['YT_KEY_4']!,
    dotenv.env['YT_KEY_5']!,
    dotenv.env['YT_KEY_6']!,
    dotenv.env['YT_KEY_7']!,
    dotenv.env['YT_KEY_8']!,
    dotenv.env['YT_KEY_9']!,
    dotenv.env['YT_KEY_10']!,
  ];

  static String get _apiKey => _apiKeys[_currentKeyIndex];

  static void _switchKey() {
    if (_currentKeyIndex < _apiKeys.length - 1) {
      _currentKeyIndex++;
    }
  }

  Future<List<Map<String, dynamic>>> searchMusic(String query) async {
    if (query.isEmpty) return [];

    final url =
        'https://www.googleapis.com/youtube/v3/search'
        '?part=snippet'
        '&type=video'
        '&maxResults=20'
        '&q=${Uri.encodeQueryComponent(query)}'
        '&key=$_apiKey';

    final response = await http.get(Uri.parse(url));

    // 🔁 QUOTA / LIMIT ERROR → SWITCH API KEY
    if (response.statusCode == 403) {
      _switchKey();
      return searchMusic(query);
    }

    if (response.statusCode != 200) return [];

    final data = json.decode(response.body);
    final items = data['items'] as List;

    return items.map((item) {
      final snippet = item['snippet'];

      return {
        'name': snippet['title'],
        'artist_name': snippet['channelTitle'],
        'videoId': item['id']['videoId'],
        'thumbnail': snippet['thumbnails']['high']['url'],
        'stream_url': null,
        'source': 'YouTube', // 🔥 ALWAYS SET
      };
    }).toList();
  }
}
