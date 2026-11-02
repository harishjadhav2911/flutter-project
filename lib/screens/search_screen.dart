import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../data/demo_movies.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';

/// Dedicated, responsive SearchScreen supporting multi-attribute searching,
/// combined genre filters, sorting options, and polished empty states.
class SearchScreen extends StatefulWidget {
  final Set<String> favoriteIds;
  final ValueChanged<Movie> onMovieTap;
  final ValueChanged<Movie> onToggleFavorite;
  final String initialQuery;

  const SearchScreen({
    super.key,
    required this.favoriteIds,
    required this.onMovieTap,
    required this.onToggleFavorite,
    this.initialQuery = '',
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;
  final Set<String> _selectedGenres = {};
  String _sortBy = 'rating'; // 'rating', 'newest', 'title'

  static const List<String> availableGenres = [
    'Action',
    'Sci-Fi',
    'Adventure',
    'Drama',
    'Animation',
    'Crime',
    'Biography',
    'Fantasy',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != oldWidget.initialQuery &&
        widget.initialQuery != _searchController.text) {
      _searchController.text = widget.initialQuery;
    }
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _toggleGenre(String genre) {
    setState(() {
      if (_selectedGenres.contains(genre)) {
        _selectedGenres.remove(genre);
      } else {
        _selectedGenres.add(genre);
      }
    });
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _selectedGenres.clear();
      _sortBy = 'rating';
    });
  }

  List<Movie> _getFilteredMovies() {
    final query = _searchController.text.trim().toLowerCase();

    final filtered = DemoMovies.allMovies.where((movie) {
      // 1. Text Query Matching across Title, Director, Cast, Overview & Genres
      final matchesQuery =
          query.isEmpty ||
          movie.title.toLowerCase().contains(query) ||
          movie.director.toLowerCase().contains(query) ||
          movie.cast.any((actor) => actor.toLowerCase().contains(query)) ||
          movie.genres.any((g) => g.toLowerCase().contains(query)) ||
          movie.overview.toLowerCase().contains(query);

      // 2. Combined Genre Filter Matching
      final matchesGenre =
          _selectedGenres.isEmpty ||
          _selectedGenres.every(
            (selected) => movie.genres.contains(selected),
          ) ||
          _selectedGenres.any((selected) => movie.genres.contains(selected));

      return matchesQuery && matchesGenre;
    }).toList();

    // 3. Sorting
    switch (_sortBy) {
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'newest':
        filtered.sort((a, b) => b.releaseYear.compareTo(a.releaseYear));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.releaseYear.compareTo(b.releaseYear));
        break;
      case 'title':
        filtered.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double horizontalPadding = isMobile ? 16 : 36;
    final results = _getFilteredMovies();
    final bool hasActiveFilters =
        _searchController.text.isNotEmpty || _selectedGenres.isNotEmpty;

    return CustomScrollView(
      slivers: [
        // Search Input Header
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              24,
              horizontalPadding,
              12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
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
                      'Search Catalog',
                      style: TextStyle(
                        fontSize: isMobile ? 22 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    if (hasActiveFilters)
                      TextButton.icon(
                        onPressed: _clearAllFilters,
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Reset All'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryRed,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search Bar Input Field
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.surfaceBorder,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    decoration: InputDecoration(
                      hintText:
                          'Search by title, director, actor, or genre (e.g. Nolan, Sci-Fi)...',
                      hintStyle: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.primaryRed,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.white54,
                                size: 20,
                              ),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Combined Genre Filter Chips
                Row(
                  children: [
                    const Text(
                      'Filter by Genre:',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_selectedGenres.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_selectedGenres.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: availableGenres.map((genre) {
                      final isSelected = _selectedGenres.contains(genre);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(genre),
                          selected: isSelected,
                          onSelected: (_) => _toggleGenre(genre),
                          selectedColor: AppColors.primaryRed,
                          backgroundColor: AppColors.surface,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primaryRed
                                  : AppColors.surfaceBorder,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Results Metadata & Sort Control Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Found ${results.length} ${results.length == 1 ? 'title' : 'titles'}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Sort: ',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                        DropdownButton<String>(
                          value: _sortBy,
                          dropdownColor: AppColors.surface,
                          underline: const SizedBox.shrink(),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.primaryRed,
                            size: 18,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'rating',
                              child: Text('Highest Rating'),
                            ),
                            DropdownMenuItem(
                              value: 'newest',
                              child: Text('Newest Release Year'),
                            ),
                            DropdownMenuItem(
                              value: 'oldest',
                              child: Text('Oldest Release Year'),
                            ),
                            DropdownMenuItem(
                              value: 'title',
                              child: Text('Alphabetical (A-Z)'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _sortBy = val);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Results Grid or Polished Empty State
        if (results.isEmpty)
          SliverFillRemaining(hasScrollBody: false, child: _buildEmptyState())
        else
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
                final movie = results[index];
                return MovieCard(
                  movie: movie,
                  isFavorite: widget.favoriteIds.contains(movie.id),
                  onTap: () => widget.onMovieTap(movie),
                  onToggleFavorite: () => widget.onToggleFavorite(movie),
                );
              }, childCount: results.length),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 48)),
      ],
    );
  }

  Widget _buildEmptyState() {
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
                Icons.search_off_rounded,
                size: 56,
                color: AppColors.primaryRed,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Matching Titles Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: const Text(
                'We couldn\'t find any movies matching your current search terms and genre filters. Try selecting different genres or clearing your query.',
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
              onPressed: _clearAllFilters,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Clear All Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
