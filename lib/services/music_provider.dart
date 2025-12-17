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

  // Get by genre (only from Jamendo for now)
  static Future<List<Map<String, dynamic>>> getByGenre(String genre) async {
    return _sources[0].fetchByGenre(genre); // Jamendo only
  }

  // Search across all sources (fixed blank screen issue)
  static Future<List<Map<String, dynamic>>> search(String query) async {
    try {
      // Fetch results from all sources in parallel
      final results = await Future.wait(
        _sources.map((source) => source.searchMusic(query)),
      );

      // Merge all results into a single list
      final mergedResults = results.expand((list) => list).toList();

      return mergedResults;
    } catch (_) {
      // If something fails, return empty list
      return [];
    }
  }
}
