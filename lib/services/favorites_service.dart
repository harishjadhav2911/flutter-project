import 'package:shared_preferences/shared_preferences.dart';

/// FavoritesService manages persistent local storage of user's saved movie IDs.
/// Backed by SharedPreferences for seamless cross-platform persistence (Android, Web, Desktop).
class FavoritesService {
  static const String _storageKey = 'flixgo_saved_movie_ids';
  static final FavoritesService instance = FavoritesService._internal();

  FavoritesService._internal();

  /// Loads saved movie IDs from SharedPreferences.
  /// If no data has been saved yet (first launch), seeds with initial demo favorites.
  Future<Set<String>> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? stored = prefs.getStringList(_storageKey);
      if (stored != null) {
        return stored.toSet();
      }
      // Initial seed on first run
      const defaultFavorites = {'dune-2', 'the-dark-knight'};
      await prefs.setStringList(_storageKey, defaultFavorites.toList());
      return defaultFavorites;
    } catch (_) {
      // Safe fallback if storage fails or in test harness
      return {'dune-2', 'the-dark-knight'};
    }
  }

  /// Persists the updated set of movie IDs to local storage.
  Future<bool> saveFavorites(Set<String> favoriteIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setStringList(_storageKey, favoriteIds.toList());
    } catch (_) {
      return false;
    }
  }

  /// Toggles a movie ID in the set and updates persistent storage.
  Future<Set<String>> toggleFavorite(
    String movieId,
    Set<String> current,
  ) async {
    final updated = Set<String>.from(current);
    if (updated.contains(movieId)) {
      updated.remove(movieId);
    } else {
      updated.add(movieId);
    }
    await saveFavorites(updated);
    return updated;
  }
}
