import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flixgo/main.dart';
import 'package:flixgo/services/favorites_service.dart';
import 'package:flixgo/widgets/flixgo_app_bar.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'flixgo_saved_movie_ids': ['dune-2', 'the-dark-knight'],
    });
  });

  testWidgets('FlixGo smoke test - renders logo, hero banner and categories', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const FlixGoApp());
    await tester.pumpAndSettle();

    // Verify FlixGo branding text in app bar
    expect(find.textContaining('FLIX'), findsWidgets);

    // Verify Hero Banner contains Dune: Part Two
    expect(find.text('Dune: Part Two'), findsWidgets);

    // Verify Action Buttons
    expect(find.text('Play Trailer'), findsOneWidget);
    expect(find.text('In My List'), findsOneWidget);

    // Verify Category Headers
    expect(find.text('Trending Now'), findsOneWidget);
    expect(find.text('Popular on FlixGo'), findsOneWidget);
    expect(find.text('Top Rated Classics'), findsOneWidget);
    expect(find.text('Sci-Fi & Cyberpunk'), findsOneWidget);
  });

  testWidgets(
    'FlixGo interactive test - toggle My List and open trailer dialog',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const FlixGoApp());
      await tester.pumpAndSettle();

      // Tap "In My List" to remove it
      final myListButton = find.text('In My List');
      expect(myListButton, findsOneWidget);
      await tester.tap(myListButton);
      await tester.pumpAndSettle();

      // Verify it updated to "My List"
      expect(find.text('My List'), findsWidgets);

      // Tap "Play Trailer"
      final trailerButton = find.text('Play Trailer');
      await tester.tap(trailerButton);
      await tester.pumpAndSettle();

      // Verify trailer dialog opened with player controls
      expect(find.textContaining('Official'), findsWidgets);
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);

      // Close trailer dialog
      final closeButton = find.byTooltip('Close Trailer');
      await tester.tap(closeButton);
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'FlixGo search test - dedicated search screen, filters, and reset',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const FlixGoApp());
      await tester.pumpAndSettle();

      // Navigate to Search screen using nav link in AppBar
      final searchNav = find.descendant(
        of: find.byType(FlixgoAppBar),
        matching: find.text('Search'),
      );
      expect(searchNav, findsOneWidget);
      await tester.tap(searchNav);
      await tester.pumpAndSettle();

      // Verify Search Screen Header
      expect(find.text('Search Catalog'), findsOneWidget);
      expect(find.text('Filter by Genre:'), findsOneWidget);

      // Enter a search query
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, 'Oppenheimer');
      await tester.pumpAndSettle();

      // Verify search result
      expect(find.text('Oppenheimer'), findsWidgets);

      // Select a genre filter
      final sciFiChip = find.text('Sci-Fi');
      expect(sciFiChip, findsWidgets);
      await tester.tap(sciFiChip.first);
      await tester.pumpAndSettle();

      // Verify reset button appears and tap it
      final resetButton = find.text('Reset All');
      expect(resetButton, findsOneWidget);
      await tester.tap(resetButton);
      await tester.pumpAndSettle();

      // Verify search field is cleared
      expect(find.text('Oppenheimer'), findsWidgets); // Still in full catalog
    },
  );

  testWidgets('FlixGo persistence test - loads and persists saved favorites', (
    WidgetTester tester,
  ) async {
    // Seed storage with custom movie ID
    SharedPreferences.setMockInitialValues({
      'flixgo_saved_movie_ids': ['oppenheimer'],
    });

    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const FlixGoApp());
    await tester.pumpAndSettle();

    // Go to My List tab (index 4)
    final myListTab = find.descendant(
      of: find.byType(FlixgoAppBar),
      matching: find.text('My List'),
    );
    expect(myListTab, findsOneWidget);
    await tester.tap(myListTab);
    await tester.pumpAndSettle();

    // Verify that seeded 'Oppenheimer' is in My List
    expect(find.textContaining('My List (1)'), findsOneWidget);
    expect(find.text('Oppenheimer'), findsWidgets);

    // Verify persistent service returns correct IDs
    final loaded = await FavoritesService.instance.loadFavorites();
    expect(loaded.contains('oppenheimer'), isTrue);
  });
}
