import 'api_interface.dart';
import 'jamendo_service.dart';

class MusicProvider {
  static final MusicAPI _api = JamendoService();

  static Future<List<Map<String, dynamic>>> getByGenre(String genre) {
    return _api.fetchByGenre(genre);
  }

  static Future<List<Map<String, dynamic>>> search(String query) {
    return _api.searchMusic(query);
  }
}

