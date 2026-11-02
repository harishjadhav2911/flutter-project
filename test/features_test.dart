import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flixgo/data/demo_movies.dart';
import 'package:flixgo/models/movie.dart';
import 'package:flixgo/services/viewing_history_service.dart';
import 'package:flixgo/screens/search_screen.dart';
import 'package:flixgo/widgets/continue_watching_section.dart';
import 'package:flixgo/widgets/profile_dialog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ViewingHistoryService Unit Tests', () {
    test(
      'loads default seeded history and continue watching when empty',
      () async {
        SharedPreferences.setMockInitialValues({});

        final history = await ViewingHistoryService.instance
            .loadRecentlyViewed();
        expect(history, contains('dune-2'));
        expect(history, contains('oppenheimer'));

        final progress = await ViewingHistoryService.instance
            .loadWatchProgress();
        expect(progress.containsKey('dune-2'), isTrue);
        expect(progress['dune-2'], greaterThan(0.0));
      },
    );

    test('restores persisted history from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'flixgo_recently_viewed_ids': ['interstellar', 'oppenheimer'],
      });

      final history = await ViewingHistoryService.instance.loadRecentlyViewed();
      expect(history, equals(['interstellar', 'oppenheimer']));
    });

    test(
      'recordView maintains maximum of 10 items and deduplicates to front',
      () async {
        SharedPreferences.setMockInitialValues({
          'flixgo_recently_viewed_ids': [
            'm1',
            'm2',
            'm3',
            'm4',
            'm5',
            'm6',
            'm7',
            'm8',
            'm9',
            'm10',
          ],
        });

        // Existing 10 items. Add 'm11'
        final history = await ViewingHistoryService.instance.recordView('m11');

        expect(history.length, 10);
        expect(history.first, 'm11');
        expect(history.contains('m10'), isFalse); // oldest dropped

        // Re-viewing m5 moves it to index 0 without duplicating
        final historyReordered = await ViewingHistoryService.instance
            .recordView('m5');
        expect(historyReordered.length, 10);
        expect(historyReordered.first, 'm5');
        expect(historyReordered.where((id) => id == 'm5').length, 1);
      },
    );

    test('clearHistory clears persisted storage and returns true', () async {
      SharedPreferences.setMockInitialValues({
        'flixgo_recently_viewed_ids': ['dune-2', 'oppenheimer'],
      });

      final success = await ViewingHistoryService.instance.clearHistory();
      expect(success, isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('flixgo_recently_viewed_ids'), isNull);
    });

    test(
      'removeFromContinueWatching removes movie ID from progress map',
      () async {
        SharedPreferences.setMockInitialValues({
          'flixgo_continue_watching_progress':
              '{"dune-2":0.65,"oppenheimer":0.42}',
        });

        await ViewingHistoryService.instance.removeFromContinueWatching(
          'dune-2',
        );
        final updated = await ViewingHistoryService.instance
            .loadWatchProgress();

        expect(updated.containsKey('dune-2'), isFalse);
        expect(updated.containsKey('oppenheimer'), isTrue);
      },
    );
  });

  group('Advanced Sorting in SearchScreen Widget Tests', () {
    testWidgets('renders sort dropdown with 4 options and changes sorting', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchScreen(
              favoriteIds: const {'dune-2'},
              onToggleFavorite: (_) {},
              onMovieTap: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find sort dropdown
      expect(find.text('Highest Rating'), findsOneWidget);

      // Open dropdown
      await tester.tap(find.text('Highest Rating'));
      await tester.pumpAndSettle();

      // Verify all 4 sort options exist
      expect(find.text('Newest Release Year'), findsOneWidget);
      expect(find.text('Oldest Release Year'), findsOneWidget);
      expect(find.text('Alphabetical (A-Z)'), findsOneWidget);

      // Select Oldest Release Year
      await tester.tap(find.text('Oldest Release Year').last);
      await tester.pumpAndSettle();

      expect(find.text('Oldest Release Year'), findsOneWidget);
    });
  });

  group('ProfileDialog Widget Tests', () {
    testWidgets(
      'displays actual counts and About FlixGo section without fake VIP',
      (WidgetTester tester) async {
        bool clearTriggered = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => ProfileDialog(
                          savedCount: 7,
                          recentlyViewedCount: 4,
                          onClearHistory: () {
                            clearTriggered = true;
                          },
                        ),
                      );
                    },
                    child: const Text('Open Profile'),
                  );
                },
              ),
            ),
          ),
        );

        // Open profile
        await tester.tap(find.text('Open Profile'));
        await tester.pumpAndSettle();

        // Verify real counts
        expect(find.text('7'), findsOneWidget); // Saved
        expect(find.text('4'), findsOneWidget); // Recently Viewed
        expect(
          find.textContaining('OPEN CATALOG'),
          findsOneWidget,
        ); // Replaced VIP badge
        expect(find.textContaining('About FlixGo'), findsOneWidget);
        expect(find.textContaining('1.0.0+1'), findsOneWidget);

        // Tap Clear History button
        final clearButton = find.text('Clear Viewing History');
        expect(clearButton, findsOneWidget);
        await tester.tap(clearButton);
        await tester.pumpAndSettle();

        // Verify confirmation dialog appears
        expect(find.text('Clear Viewing History?'), findsOneWidget);

        // Tap Confirm Clear button
        final confirmButton = find.widgetWithText(
          ElevatedButton,
          'Clear History',
        );
        expect(confirmButton, findsOneWidget);
        await tester.tap(confirmButton);
        await tester.pumpAndSettle();

        expect(clearTriggered, isTrue);
      },
    );
  });

  group('ContinueWatchingSection Widget Tests', () {
    testWidgets(
      'renders continue watching cards with demo progress and actions',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        Movie? playedMovie;
        Movie? dismissedMovie;

        final testMovies = [
          DemoMovies.allMovies.first,
          DemoMovies.allMovies[1],
        ];
        final testProgress = {
          DemoMovies.allMovies.first.id: 0.65,
          DemoMovies.allMovies[1].id: 0.30,
        };

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ContinueWatchingSection(
                  movies: testMovies,
                  progressMap: testProgress,
                  onMovieTap: (_) {},
                  onPlayTrailer: (m) => playedMovie = m,
                  onRemove: (m) => dismissedMovie = m,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify Section Title and Demo Progress badge
        expect(find.text('Continue Watching'), findsOneWidget);
        expect(find.text('DEMO PROGRESS'), findsOneWidget);

        // Verify Percentage texts
        expect(find.textContaining('65%'), findsOneWidget);
        expect(find.textContaining('30%'), findsOneWidget);

        // Tap play button on first card
        final playButton = find.byTooltip('Continue Watching Dune: Part Two');
        expect(playButton, findsOneWidget);
        await tester.tap(playButton);
        await tester.pumpAndSettle();
        expect(playedMovie?.id, equals('dune-2'));

        // Tap remove button on second card
        final removeButtons = find.byTooltip('Remove from Continue Watching');
        expect(removeButtons, findsNWidgets(2));
        await tester.tap(removeButtons.at(1));
        await tester.pumpAndSettle();
        expect(dismissedMovie?.id, equals(DemoMovies.allMovies[1].id));
      },
    );
  });
}
