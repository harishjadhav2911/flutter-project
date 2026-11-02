import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../data/demo_movies.dart';
import '../models/movie.dart';
import '../services/favorites_service.dart';
import '../services/viewing_history_service.dart';
import '../widgets/continue_watching_section.dart';
import '../widgets/flixgo_app_bar.dart';
import '../widgets/hero_banner.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_carousel_section.dart';
import '../widgets/movie_details_dialog.dart';
import '../widgets/profile_dialog.dart';
import '../widgets/trailer_preview_dialog.dart';
import 'search_screen.dart';

/// HomeScreen is the central responsive streaming experience for FlixGo.
/// Coordinates 5 main navigation destinations: Home, Movies, Series, Search, and My List,
/// backed by persistent local storage (Stage 4).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Navigation: 0 = Home, 1 = Movies, 2 = Series, 3 = Search, 4 = My List
  int _selectedTabIndex = 0;

  // Persistent Favorites State (Single Source of Truth)
  Set<String> _favoriteMovieIds = {'dune-2', 'the-dark-knight'};
  bool _isLoadingFavorites = true;

  // Persistent Viewing History & Continue Watching State
  List<String> _recentlyViewedIds = [];
  Map<String, double> _watchProgress = {};

  @override
  void initState() {
    super.initState();
    _loadFavoritesFromStorage();
    _loadHistoryFromStorage();
  }

  /// Loads saved favorite IDs from SharedPreferences on application startup.
  Future<void> _loadFavoritesFromStorage() async {
    final loaded = await FavoritesService.instance.loadFavorites();
    if (!mounted) return;
    setState(() {
      _favoriteMovieIds = loaded;
      _isLoadingFavorites = false;
    });
  }

  /// Loads viewing history and continue-watching demo progress from SharedPreferences.
  Future<void> _loadHistoryFromStorage() async {
    final viewed = await ViewingHistoryService.instance.loadRecentlyViewed();
    final progress = await ViewingHistoryService.instance.loadWatchProgress();
    if (!mounted) return;
    setState(() {
      _recentlyViewedIds = viewed;
      _watchProgress = progress;
    });
  }

  /// Records that a movie was viewed, updating history and local storage.
  Future<void> _recordMovieView(String movieId) async {
    final updated = await ViewingHistoryService.instance.recordView(movieId);
    final progress = await ViewingHistoryService.instance.loadWatchProgress();
    if (!mounted) return;
    setState(() {
      _recentlyViewedIds = updated;
      _watchProgress = progress;
    });
  }

  /// Clears all viewing history and continue-watching progress.
  Future<void> _clearViewingHistory() async {
    await ViewingHistoryService.instance.clearHistory();
    if (!mounted) return;
    setState(() {
      _recentlyViewedIds = [];
      _watchProgress = {};
    });
  }

  /// Removes an individual title from Continue Watching.
  Future<void> _removeFromContinueWatching(Movie movie) async {
    await ViewingHistoryService.instance.removeFromContinueWatching(movie.id);
    final progress = await ViewingHistoryService.instance.loadWatchProgress();
    if (!mounted) return;
    setState(() {
      _watchProgress = progress;
    });
    _showSnackBar('Removed "${movie.title}" from Continue Watching');
  }

  /// Prompts user with a confirmation dialog before clearing viewing history.
  void _confirmAndClearHistory() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.surfaceBorder, width: 0.8),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.delete_forever_rounded,
              color: AppColors.primaryRed,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Clear Viewing History?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'This will permanently clear all recently viewed titles and continue-watching progress. This action cannot be undone.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _clearViewingHistory();
              _showSnackBar('Viewing history cleared');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear History'),
          ),
        ],
      ),
    );
  }

  /// Toggles a movie in/out of My List and persists it immediately to local storage.
  Future<void> _toggleFavorite(Movie movie) async {
    final updated = await FavoritesService.instance.toggleFavorite(
      movie.id,
      _favoriteMovieIds,
    );
    if (!mounted) return;

    final isSaved = updated.contains(movie.id);
    setState(() {
      _favoriteMovieIds = updated;
    });

    _showSnackBar(
      isSaved
          ? 'Added "${movie.title}" to My List'
          : 'Removed "${movie.title}" from My List',
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.surfaceLight,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openMovieDetails(Movie movie) {
    _recordMovieView(movie.id);
    MovieDetailsDialog.show(
      context,
      movie: movie,
      isFavorite: _favoriteMovieIds.contains(movie.id),
      onToggleFavorite: () => _toggleFavorite(movie),
      onPlayTrailer: () => _openTrailer(movie),
    );
  }

  void _openTrailer(Movie movie) {
    TrailerPreviewDialog.show(context, movie);
  }

  void _openProfile() {
    ProfileDialog.show(
      context,
      savedCount: _favoriteMovieIds.length,
      recentlyViewedCount: _recentlyViewedIds.length,
      onClearHistory: _clearViewingHistory,
    );
  }

  void _navigateToTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: FlixgoAppBar(
        selectedTabIndex: _selectedTabIndex,
        onTabSelected: _navigateToTab,
        onSearchTap: () => _navigateToTab(3), // Navigate to Search tab
        onProfileTap: _openProfile,
      ),
      body: _buildCurrentBody(),
      bottomNavigationBar: isMobile ? _buildMobileBottomBar() : null,
    );
  }

  Widget _buildCurrentBody() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildFilteredCategoryTab('Movies', isSeriesOnly: false);
      case 2:
        return _buildFilteredCategoryTab('Series', isSeriesOnly: true);
      case 3:
        return SearchScreen(
          favoriteIds: _favoriteMovieIds,
          onMovieTap: _openMovieDetails,
          onToggleFavorite: _toggleFavorite,
        );
      case 4:
        return _buildMyListTab();
      default:
        return _buildHomeTab();
    }
  }

  /// Tab 0: Home view featuring Hero Banner & categorized Carousels
  Widget _buildHomeTab() {
    final featured = DemoMovies.featuredMovie;
    final isFeaturedFavorite = _favoriteMovieIds.contains(featured.id);

    // Map watch progress IDs to Movie objects for Continue Watching
    final continueWatchingMovies = _watchProgress.keys
        .map(
          (id) => DemoMovies.allMovies.cast<Movie?>().firstWhere(
            (m) => m?.id == id,
            orElse: () => null,
          ),
        )
        .whereType<Movie>()
        .toList();

    // Map history IDs to Movie objects for Recently Viewed (latest 10)
    final recentlyViewedMovies = _recentlyViewedIds
        .map(
          (id) => DemoMovies.allMovies.cast<Movie?>().firstWhere(
            (m) => m?.id == id,
            orElse: () => null,
          ),
        )
        .whereType<Movie>()
        .toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cinematic Hero Banner
          HeroBanner(
            movie: featured,
            isFavorite: isFeaturedFavorite,
            onPlayTrailer: () => _openTrailer(featured),
            onToggleFavorite: () => _toggleFavorite(featured),
            onMoreInfo: () => _openMovieDetails(featured),
          ),

          const SizedBox(height: 8),

          // Continue Watching Section (Feature 1)
          if (continueWatchingMovies.isNotEmpty) ...[
            ContinueWatchingSection(
              movies: continueWatchingMovies,
              progressMap: _watchProgress,
              onMovieTap: _openMovieDetails,
              onPlayTrailer: _openTrailer,
              onRemove: _removeFromContinueWatching,
            ),
            const SizedBox(height: 12),
          ],

          // Recently Viewed Section (Feature 2)
          if (recentlyViewedMovies.isNotEmpty) ...[
            MovieCarouselSection(
              title: 'Recently Viewed',
              movies: recentlyViewedMovies,
              favoriteIds: _favoriteMovieIds,
              onMovieTap: _openMovieDetails,
              onToggleFavorite: _toggleFavorite,
              onClearAction: _confirmAndClearHistory,
              clearActionLabel: 'Clear History',
            ),
            const SizedBox(height: 12),
          ],

          // Horizontal Movie Rows
          MovieCarouselSection(
            title: 'Trending Now',
            movies: DemoMovies.trending,
            favoriteIds: _favoriteMovieIds,
            onMovieTap: _openMovieDetails,
            onToggleFavorite: _toggleFavorite,
            onSeeAll: () => _navigateToTab(1),
          ),

          const SizedBox(height: 12),

          MovieCarouselSection(
            title: 'Popular on FlixGo',
            movies: DemoMovies.popular,
            favoriteIds: _favoriteMovieIds,
            onMovieTap: _openMovieDetails,
            onToggleFavorite: _toggleFavorite,
            onSeeAll: () => _navigateToTab(1),
          ),

          const SizedBox(height: 12),

          MovieCarouselSection(
            title: 'Top Rated Classics',
            movies: DemoMovies.topRated,
            favoriteIds: _favoriteMovieIds,
            onMovieTap: _openMovieDetails,
            onToggleFavorite: _toggleFavorite,
            onSeeAll: () => _navigateToTab(1),
          ),

          const SizedBox(height: 12),

          MovieCarouselSection(
            title: 'Sci-Fi & Cyberpunk',
            movies: DemoMovies.sciFi,
            favoriteIds: _favoriteMovieIds,
            onMovieTap: _openMovieDetails,
            onToggleFavorite: _toggleFavorite,
            onSeeAll: () => _navigateToTab(1),
          ),

          const SizedBox(height: 48),

          _buildFooter(),
        ],
      ),
    );
  }

  /// Tab 1 & 2: Categorized full-screen grid
  Widget _buildFilteredCategoryTab(String title, {required bool isSeriesOnly}) {
    final movies = isSeriesOnly
        ? DemoMovies.allMovies
              .where(
                (m) =>
                    m.duration.contains('Season') ||
                    m.genres.contains('Animation'),
              )
              .toList()
        : DemoMovies.allMovies
              .where((m) => !m.duration.contains('Season'))
              .toList();

    return _buildMovieGridPage(
      title: title,
      movies: movies,
      emptyMessage: 'No $title currently available.',
    );
  }

  /// Tab 4: My List view (Saved Movies from persistent storage)
  Widget _buildMyListTab() {
    if (_isLoadingFavorites) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryRed),
      );
    }

    final myMovies = DemoMovies.allMovies
        .where((m) => _favoriteMovieIds.contains(m.id))
        .toList();

    if (myMovies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surfaceBorder, width: 1),
                ),
                child: const Icon(
                  Icons.bookmark_outline_rounded,
                  size: 54,
                  color: AppColors.primaryRed,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your List is Empty',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: const Text(
                  'Movies and series you add to My List are saved permanently to your device so you can easily find them later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _navigateToTab(0),
                icon: const Icon(Icons.explore_rounded),
                label: const Text('Browse Featured Movies'),
              ),
            ],
          ),
        ),
      );
    }

    return _buildMovieGridPage(
      title: 'My List (${myMovies.length})',
      movies: myMovies,
      emptyMessage: 'No saved movies.',
    );
  }

  Widget _buildMovieGridPage({
    required String title,
    required List<Movie> movies,
    required String emptyMessage,
  }) {
    final bool isMobile = Responsive.isMobile(context);
    final double horizontalPadding = isMobile ? 16 : 36;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              24,
              horizontalPadding,
              16,
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 22 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  '${movies.length} titles',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 8,
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: isMobile ? 150 : 200,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final movie = movies[index];
              return MovieCard(
                movie: movie,
                isFavorite: _favoriteMovieIds.contains(movie.id),
                onTap: () => _openMovieDetails(movie),
                onToggleFavorite: () => _toggleFavorite(movie),
              );
            }, childCount: movies.length),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 48)),
      ],
    );
  }

  Widget _buildMobileBottomBar() {
    return NavigationBar(
      selectedIndex: _selectedTabIndex,
      onDestinationSelected: _navigateToTab,
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primaryRed.withValues(alpha: 0.25),
      elevation: 8,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_filled, color: AppColors.primaryRed),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.movie_outlined),
          selectedIcon: Icon(Icons.movie_rounded, color: AppColors.primaryRed),
          label: 'Movies',
        ),
        NavigationDestination(
          icon: Icon(Icons.tv_outlined),
          selectedIcon: Icon(Icons.tv_rounded, color: AppColors.primaryRed),
          label: 'Series',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_rounded),
          selectedIcon: Icon(Icons.search_rounded, color: AppColors.primaryRed),
          label: 'Search',
        ),
        NavigationDestination(
          icon: Icon(Icons.bookmark_outline_rounded),
          selectedIcon: Icon(
            Icons.bookmark_rounded,
            color: AppColors.primaryRed,
          ),
          label: 'My List',
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      color: AppColors.backgroundSecondary,
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_arrow_rounded,
                color: AppColors.primaryRed,
                size: 20,
              ),
              SizedBox(width: 6),
              Text(
                'FLIXGO STREAMING',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Built with Flutter & Dart • Responsive for Android, Web, and Desktop',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          SizedBox(height: 6),
          Text(
            '© 2026 FlixGo Inc. All movie rights belong to their respective creators.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
