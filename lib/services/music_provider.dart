import 'api_interface.dart';
import 'jamendo_service.dart';
import 'archive_service.dart';
import 'fma_service.dart';

class MusicProvider {
  // All sources
  static final List<MusicAPI> _sources = [
    JamendoService(),
    ArchiveService(),
    FmaService(),
  ];

  // Get by genre (Jamendo only) – optional
  static Future<List<Map<String, dynamic>>> getByGenre(String genre) async {
    try {
      return await _sources[0].fetchByGenre(genre);
    } catch (_) {
      return [];
    }
  }

  // Search across all sources
  // If query is empty, it will fetch top/default tracks from all sources
  static Future<List<Map<String, dynamic>>> search(String query) async {
    try {
      // Fetch from all sources in parallel
      final results = await Future.wait(
        _sources.map((source) => source.searchMusic(query)),
      );

      // Merge all results into a single list
      final mergedResults = results.expand((list) => list).toList();

      return mergedResults;
    } catch (_) {
      return [];
    }
  }
}
