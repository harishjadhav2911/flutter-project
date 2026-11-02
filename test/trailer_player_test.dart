import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flixgo/data/demo_movies.dart';
import 'package:flixgo/models/movie.dart';
import 'package:flixgo/widgets/movie_details_dialog.dart';
import 'package:flixgo/widgets/trailer_preview_dialog.dart';

void main() {
  group('Movie YouTube Model Tests', () {
    test('extracts 11-char video ID from standard YouTube watch URL', () {
      const movie = Movie(
        id: 'test-1',
        title: 'Test Movie',
        overview: 'Overview',
        posterUrl: 'https://example.com/poster.jpg',
        backdropUrl: 'https://example.com/backdrop.jpg',
        rating: 8.5,
        voteCount: 100,
        releaseYear: 2024,
        duration: '2h',
        genres: ['Action'],
        director: 'Director',
        cast: ['Actor'],
        category: 'popular',
        trailerUrl: 'https://www.youtube.com/watch?v=Way9Dexny3w',
      );

      expect(movie.youtubeVideoId, equals('Way9Dexny3w'));
      expect(movie.hasTrailer, isTrue);
      expect(
        movie.youtubeWatchUrl,
        equals('https://www.youtube.com/watch?v=Way9Dexny3w'),
      );
    });

    test('extracts 11-char video ID from youtu.be short URL', () {
      const movie = Movie(
        id: 'test-2',
        title: 'Test Movie',
        overview: 'Overview',
        posterUrl: 'https://example.com/poster.jpg',
        backdropUrl: 'https://example.com/backdrop.jpg',
        rating: 8.5,
        voteCount: 100,
        releaseYear: 2024,
        duration: '2h',
        genres: ['Action'],
        director: 'Director',
        cast: ['Actor'],
        category: 'popular',
        trailerUrl: 'https://youtu.be/Way9Dexny3w',
      );

      expect(movie.youtubeVideoId, equals('Way9Dexny3w'));
      expect(movie.hasTrailer, isTrue);
    });

    test('extracts 11-char video ID from raw ID string', () {
      const movie = Movie(
        id: 'test-3',
        title: 'Test Movie',
        overview: 'Overview',
        posterUrl: 'https://example.com/poster.jpg',
        backdropUrl: 'https://example.com/backdrop.jpg',
        rating: 8.5,
        voteCount: 100,
        releaseYear: 2024,
        duration: '2h',
        genres: ['Action'],
        director: 'Director',
        cast: ['Actor'],
        category: 'popular',
        trailerUrl: 'Way9Dexny3w',
      );

      expect(movie.youtubeVideoId, equals('Way9Dexny3w'));
      expect(movie.hasTrailer, isTrue);
    });

    test('returns null when trailer is empty or not YouTube', () {
      const emptyMovie = Movie(
        id: 'test-4',
        title: 'Test Movie',
        overview: 'Overview',
        posterUrl: 'https://example.com/poster.jpg',
        backdropUrl: 'https://example.com/backdrop.jpg',
        rating: 8.5,
        voteCount: 100,
        releaseYear: 2024,
        duration: '2h',
        genres: ['Action'],
        director: 'Director',
        cast: ['Actor'],
        category: 'popular',
        trailerUrl: '',
      );

      expect(emptyMovie.youtubeVideoId, isNull);
      expect(emptyMovie.hasTrailer, isFalse);
      expect(emptyMovie.youtubeWatchUrl, isNull);

      const sampleMovie = Movie(
        id: 'test-5',
        title: 'Sample Movie',
        overview: 'Overview',
        posterUrl: 'https://example.com/poster.jpg',
        backdropUrl: 'https://example.com/backdrop.jpg',
        rating: 8.5,
        voteCount: 100,
        releaseYear: 2024,
        duration: '2h',
        genres: ['Action'],
        director: 'Director',
        cast: ['Actor'],
        category: 'popular',
        trailerUrl: 'https://example.com/sample.mp4',
      );

      expect(sampleMovie.youtubeVideoId, isNull);
      expect(sampleMovie.hasTrailer, isFalse);
    });

    test('all demo movies have valid YouTube video IDs', () {
      for (final movie in DemoMovies.allMovies) {
        expect(
          movie.hasTrailer,
          isTrue,
          reason:
              '${movie.title} should have a valid YouTube trailer configured',
        );
        expect(
          movie.youtubeVideoId,
          isNotNull,
          reason: '${movie.title} youtubeVideoId should not be null',
        );
        expect(
          movie.youtubeVideoId!.length,
          equals(11),
          reason: '${movie.title} youtubeVideoId must be 11 characters',
        );
      }
    });

    test(
      'Dune: Part Two backdrop is fixed and does not contain controller image',
      () {
        final dune = DemoMovies.featuredMovie;
        expect(
          dune.backdropUrl.contains('photo-1509198397868-475647b2a1e5'),
          isFalse,
        );
        expect(dune.backdropUrl.contains('photo-1509316975850'), isTrue);
      },
    );
  });

  group('TrailerPlayerDialog Widget Tests', () {
    testWidgets(
      'renders dialog with official trailer header, player controls, and closes',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final movie = DemoMovies.featuredMovie;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => TrailerPreviewDialog.show(context, movie),
                    child: const Text('Open Trailer'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Trailer'));
        await tester.pumpAndSettle();

        // Verify Trailer Header
        expect(find.text('TRAILER'), findsOneWidget);
        expect(find.textContaining('Dune: Part Two'), findsWidgets);

        // Verify Player Controls
        expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
        expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
        expect(find.byIcon(Icons.fullscreen_rounded), findsOneWidget);
        expect(find.text('YouTube'), findsOneWidget);

        // Tap Play/Pause toggle
        await tester.tap(find.byIcon(Icons.pause_rounded));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.play_arrow_rounded), findsWidgets);

        // Close dialog
        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pumpAndSettle();
        expect(find.text('TRAILER'), findsNothing);
      },
    );

    testWidgets('renders "Trailer Unavailable" state when movie has no trailer', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const movieWithoutTrailer = Movie(
        id: 'no-trailer',
        title: 'Unreleased Mystery',
        overview: 'A movie without any trailer yet.',
        posterUrl: 'https://example.com/poster.jpg',
        backdropUrl: 'https://example.com/backdrop.jpg',
        rating: 7.0,
        voteCount: 10,
        releaseYear: 2025,
        duration: '1h 30m',
        genres: ['Mystery'],
        director: 'Unknown',
        cast: ['Unknown'],
        category: 'popular',
        trailerUrl: '',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () =>
                      TrailerPreviewDialog.show(context, movieWithoutTrailer),
                  child: const Text('Open Unavailable Trailer'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Unavailable Trailer'));
      await tester.pumpAndSettle();

      // Verify clear "Trailer Unavailable" message (Requirement 8)
      expect(find.text('Trailer Unavailable'), findsOneWidget);
      expect(
        find.textContaining(
          'An official trailer has not been configured or is temporarily unavailable',
        ),
        findsOneWidget,
      );

      // Close button closes dialog
      await tester.tap(find.widgetWithText(OutlinedButton, 'Close'));
      await tester.pumpAndSettle();
      expect(find.text('Trailer Unavailable'), findsNothing);
    });

    testWidgets(
      'MovieDetailsDialog triggers trailer playback via Play Trailer button',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        bool trailerPlayed = false;
        final movie = DemoMovies.featuredMovie;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      MovieDetailsDialog.show(
                        context,
                        movie: movie,
                        isFavorite: false,
                        onToggleFavorite: () {},
                        onPlayTrailer: () {
                          trailerPlayed = true;
                        },
                      );
                    },
                    child: const Text('Open Details'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Details'));
        await tester.pumpAndSettle();

        // MovieDetailsDialog is visible
        expect(find.text('Dune: Part Two'), findsWidgets);
        expect(find.text('Play Trailer'), findsOneWidget);

        // Tap Play Trailer
        await tester.tap(find.text('Play Trailer'));
        await tester.pumpAndSettle();

        expect(trailerPlayed, isTrue);
      },
    );
  });
}
