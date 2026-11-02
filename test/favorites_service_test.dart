import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flixgo/services/favorites_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FavoritesService Unit Tests', () {
    test('loadFavorites returns default favorites when unseeded', () async {
      SharedPreferences.setMockInitialValues({});

      final favorites = await FavoritesService.instance.loadFavorites();
      expect(favorites, contains('dune-2'));
      expect(favorites, contains('the-dark-knight'));
    });

    test('loadFavorites restores persisted list from storage', () async {
      SharedPreferences.setMockInitialValues({
        'flixgo_saved_movie_ids': ['oppenheimer', 'interstellar'],
      });

      final favorites = await FavoritesService.instance.loadFavorites();
      expect(favorites.length, 2);
      expect(favorites, contains('oppenheimer'));
      expect(favorites, contains('interstellar'));
    });

    test(
      'toggleFavorite adds and removes IDs and persists correctly',
      () async {
        SharedPreferences.setMockInitialValues({
          'flixgo_saved_movie_ids': ['oppenheimer'],
        });

        // Add 'inception'
        final afterAdd = await FavoritesService.instance.toggleFavorite(
          'inception',
          {'oppenheimer'},
        );
        expect(afterAdd.contains('inception'), isTrue);
        expect(afterAdd.contains('oppenheimer'), isTrue);

        // Remove 'oppenheimer'
        final afterRemove = await FavoritesService.instance.toggleFavorite(
          'oppenheimer',
          afterAdd,
        );
        expect(afterRemove.contains('oppenheimer'), isFalse);
        expect(afterRemove.contains('inception'), isTrue);

        // Verify SharedPreferences updated
        final prefs = await SharedPreferences.getInstance();
        final stored = prefs.getStringList('flixgo_saved_movie_ids');
        expect(stored, equals(['inception']));
      },
    );
  });
}
