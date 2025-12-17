import 'api_interface.dart';
import 'jamendo_service.dart';
import 'archive_service.dart';
import 'fma_service.dart';
import 'youtube_service.dart';

class MusicProvider {
  // All sources (ORDER MATTERS for UX)
  static final List<dynamic> _sources = [
    YouTubeService(),     // 🔥 YouTube FIRST (most results)
    JamendoService(),
    ArchiveService(),
    FmaService(),
  ];

  // Get by genre (Jamendo only – safe)
  static Future<List<Map<String, dynamic>>> getByGenre(String genre) async {
    try {
      return await JamendoService().fetchByGenre(genre);
    } catch (_) {
      return [];
    }
  }

  // Search across ALL sources
  static Future<List<Map<String, dynamic>>> search(String query) async {
    final List<Map<String, dynamic>> mergedResults = [];

    for (final source in _sources) {
      try {
        final List<Map<String, dynamic>> res =
            await source.searchMusic(query);
        mergedResults.addAll(res);
      } catch (_) {
        // ignore failed source
      }
    }

    return mergedResults;
  }
}
