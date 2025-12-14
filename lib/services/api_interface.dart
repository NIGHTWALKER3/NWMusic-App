abstract class MusicAPI {
  Future<List<Map<String, dynamic>>> fetchByGenre(String genre);
  Future<List<Map<String, dynamic>>> searchMusic(String query);
}

