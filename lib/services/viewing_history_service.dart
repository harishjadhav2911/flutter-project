import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// ViewingHistoryService manages persistent local storage of:
/// 1. Recently viewed movie IDs (up to 10 unique items, ordered by recency).
/// 2. Demo watch progress percentage for the Continue Watching feature.
/// Backed by SharedPreferences for seamless persistence across Android and Web.
class ViewingHistoryService {
  static const String _historyKey = 'flixgo_recently_viewed_ids';
  static const String _progressKey = 'flixgo_continue_watching_progress';

  static final ViewingHistoryService instance =
      ViewingHistoryService._internal();

  ViewingHistoryService._internal();

  /// Default demo seed when launching the app for the very first time.
  static const List<String> defaultHistory = [
    'dune-2',
    'interstellar',
    'cyberpunk-neon',
    'oppenheimer',
  ];

  static const Map<String, double> defaultProgress = {
    'dune-2': 0.68,
    'interstellar': 0.42,
    'cyberpunk-neon': 0.85,
    'oppenheimer': 0.25,
  };

  /// Loads the recently viewed movie IDs from persistent storage.
  /// If unseeded, seeds with initial demo titles so the UI is immediately engaging.
  Future<List<String>> loadRecentlyViewed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? stored = prefs.getStringList(_historyKey);
      if (stored != null) {
        return stored;
      }
      // Initial seed on first run
      await prefs.setStringList(_historyKey, defaultHistory);
      return List<String>.from(defaultHistory);
    } catch (_) {
      return List<String>.from(defaultHistory);
    }
  }

  /// Loads watch progress map (movieId -> fraction from 0.0 to 1.0).
  Future<Map<String, double>> loadWatchProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString(_progressKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
        return decoded.map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        );
      }
      // Seed default progress
      await saveAllProgress(defaultProgress);
      return Map<String, double>.from(defaultProgress);
    } catch (_) {
      return Map<String, double>.from(defaultProgress);
    }
  }

  /// Saves the full map of watch progress to local storage.
  Future<bool> saveAllProgress(Map<String, double> progressMap) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_progressKey, jsonEncode(progressMap));
    } catch (_) {
      return false;
    }
  }

  /// Records a view for the given [movieId].
  /// - Moves or adds [movieId] to index 0.
  /// - Limits list to the latest 10 unique movies.
  /// - Ensures demo watch progress is initialized if missing.
  Future<List<String>> recordView(String movieId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> current =
          prefs.getStringList(_historyKey) ?? List<String>.from(defaultHistory);

      final updated = List<String>.from(current);
      updated.remove(movieId);
      updated.insert(0, movieId);

      // Limit to 10 unique movies (Requirement: Feature 2)
      final limited = updated.take(10).toList();
      await prefs.setStringList(_historyKey, limited);

      // Ensure demo watch progress exists
      final progressMap = await loadWatchProgress();
      if (!progressMap.containsKey(movieId)) {
        // Assign realistic demo progress between 30% and 75%
        progressMap[movieId] = 0.45;
        await saveAllProgress(progressMap);
      }

      return limited;
    } catch (_) {
      return [movieId];
    }
  }

  /// Clears all viewing history and continue-watching progress.
  Future<bool> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
      await prefs.remove(_progressKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Removes an individual movie from the Continue Watching section.
  Future<void> removeFromContinueWatching(String movieId) async {
    try {
      final progressMap = await loadWatchProgress();
      if (progressMap.containsKey(movieId)) {
        progressMap.remove(movieId);
        await saveAllProgress(progressMap);
      }
    } catch (_) {}
  }

  /// Updates progress for a movie (e.g. 0.0 to 1.0).
  Future<void> updateProgress(String movieId, double progress) async {
    try {
      final progressMap = await loadWatchProgress();
      progressMap[movieId] = progress.clamp(0.0, 1.0);
      await saveAllProgress(progressMap);
    } catch (_) {}
  }
}
