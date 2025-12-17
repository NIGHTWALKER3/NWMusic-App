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
    // You can extend other sources later if needed
    return _sources[0].fetchByGenre(genre); // Jamendo only
  }

  // Search across all sources
  static Future<List<Map<String, dynamic>>> search(String query) async {
    final List<Map<String, dynamic>> results = [];

    for (final source in _sources) {
      try {
        final res = await source.searchMusic(query);
        results.addAll(res);
      } catch (_) {
        // Ignore failed source
      }
    }

    return results;
  }
}
