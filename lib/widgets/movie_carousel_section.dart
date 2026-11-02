import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../models/movie.dart';
import 'movie_card.dart';

/// MovieCarouselSection displays a categorized row of movies
/// with a title, "See All" action, and horizontal scrolling.
class MovieCarouselSection extends StatefulWidget {
  final String title;
  final List<Movie> movies;
  final Set<String> favoriteIds;
  final ValueChanged<Movie> onMovieTap;
  final ValueChanged<Movie> onToggleFavorite;
  final VoidCallback? onSeeAll;
  final VoidCallback? onClearAction;
  final String? clearActionLabel;

  const MovieCarouselSection({
    super.key,
    required this.title,
    required this.movies,
    required this.favoriteIds,
    required this.onMovieTap,
    required this.onToggleFavorite,
    this.onSeeAll,
    this.onClearAction,
    this.clearActionLabel,
  });

  @override
  State<MovieCarouselSection> createState() => _MovieCarouselSectionState();
}

class _MovieCarouselSectionState extends State<MovieCarouselSection> {
  final ScrollController _scrollController = ScrollController();

  void _scroll(double offset) {
    _scrollController.animateTo(
      _scrollController.offset + offset,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox.shrink();

    final bool isMobile = Responsive.isMobile(context);
    final double cardWidth = isMobile ? 135 : 165;
    final double cardHeight = isMobile ? 205 : 245;
    final double horizontalPadding = isMobile ? 16 : 32;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 8,
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              if (widget.onClearAction != null)
                TextButton.icon(
                  onPressed: widget.onClearAction,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 15,
                    color: AppColors.textMuted,
                  ),
                  label: Text(
                    widget.clearActionLabel ?? 'Clear History',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              if (widget.onSeeAll != null)
                TextButton(
                  onPressed: widget.onSeeAll,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryRed,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 12),
                    ],
                  ),
                ),
              // Desktop arrow scroll navigation
              if (!isMobile) ...[
                const SizedBox(width: 6),
                IconButton(
                  onPressed: () => _scroll(-cardWidth * 2),
                  icon: const Icon(Icons.chevron_left_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    iconSize: 20,
                    padding: const EdgeInsets.all(6),
                    minimumSize: const Size(32, 32),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => _scroll(cardWidth * 2),
                  icon: const Icon(Icons.chevron_right_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    iconSize: 20,
                    padding: const EdgeInsets.all(6),
                    minimumSize: const Size(32, 32),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Horizontal List
        SizedBox(
          height: cardHeight + 16,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 8,
            ),
            itemCount: widget.movies.length,
            separatorBuilder: (_, _) => SizedBox(width: isMobile ? 12 : 16),
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
              final isFavorite = widget.favoriteIds.contains(movie.id);

              return MovieCard(
                movie: movie,
                width: cardWidth,
                height: cardHeight,
                isFavorite: isFavorite,
                onTap: () => widget.onMovieTap(movie),
                onToggleFavorite: () => widget.onToggleFavorite(movie),
              );
            },
          ),
        ),
      ],
    );
  }
}
