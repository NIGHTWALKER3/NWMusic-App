import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_interface.dart';

class JamendoService implements MusicAPI {
  static const String clientId = "daca300a";

  @override
  Future<List<Map<String, dynamic>>> fetchByGenre(String genre) async {
    final url = Uri.parse(
      "https://api.jamendo.com/v3.0/tracks"
      "?client_id=$clientId"
      "&format=json"
      "&limit=20"
      "&tags=$genre"
      "&audioformat=mp31",
    );

    final response = await http.get(url);
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  @override
  Future<List<Map<String, dynamic>>> searchMusic(String query) async {
    final url = Uri.parse(
      "https://api.jamendo.com/v3.0/tracks"
      "?client_id=$clientId"
      "&format=json"
      "&limit=20"
      "&search=$query",
    );

    final response = await http.get(url);
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }
}

