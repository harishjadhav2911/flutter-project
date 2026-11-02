import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../models/movie.dart';
import 'network_movie_image.dart';

/// ContinueWatchingSection displays horizontal widescreen cards for recently
/// opened movies with visual progress bars and clearly labeled demo indicators.
class ContinueWatchingSection extends StatelessWidget {
  final List<Movie> movies;
  final Map<String, double> progressMap;
  final ValueChanged<Movie> onMovieTap;
  final ValueChanged<Movie> onPlayTrailer;
  final ValueChanged<Movie> onRemove;

  const ContinueWatchingSection({
    super.key,
    required this.movies,
    required this.progressMap,
    required this.onMovieTap,
    required this.onPlayTrailer,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    final bool isMobile = Responsive.isMobile(context);
    final double horizontalPadding = isMobile ? 16 : 36;
    final double cardWidth = isMobile ? 240 : 280;
    final double cardHeight = isMobile ? 160 : 185;

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
              const Text(
                'Continue Watching',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.surfaceBorder,
                    width: 0.6,
                  ),
                ),
                child: const Text(
                  'DEMO PROGRESS',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Horizontal Carousel
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 6,
            ),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: movies.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final movie = movies[index];
              final double progress = (progressMap[movie.id] ?? 0.45).clamp(
                0.05,
                0.95,
              );
              return _ContinueWatchingCard(
                movie: movie,
                progress: progress,
                width: cardWidth,
                onTap: () => onMovieTap(movie),
                onPlay: () => onPlayTrailer(movie),
                onRemove: () => onRemove(movie),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ContinueWatchingCard extends StatefulWidget {
  final Movie movie;
  final double progress;
  final double width;
  final VoidCallback onTap;
  final VoidCallback onPlay;
  final VoidCallback onRemove;

  const _ContinueWatchingCard({
    required this.movie,
    required this.progress,
    required this.width,
    required this.onTap,
    required this.onPlay,
    required this.onRemove,
  });

  @override
  State<_ContinueWatchingCard> createState() => _ContinueWatchingCardState();
}

class _ContinueWatchingCardState extends State<_ContinueWatchingCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final int percent = (widget.progress * 100).toInt();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: Container(
            width: widget.width,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isHovered
                    ? AppColors.primaryRed.withValues(alpha: 0.6)
                    : AppColors.surfaceBorder,
                width: 0.8,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.primaryRed.withValues(alpha: 0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Video Frame with Play Overlay
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      NetworkMovieImage(
                        imageUrl: widget.movie.backdropUrl.isNotEmpty
                            ? widget.movie.backdropUrl
                            : widget.movie.posterUrl,
                        fallbackTitle: widget.movie.title,
                        fit: BoxFit.cover,
                      ),
                      // Dark gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.75),
                            ],
                          ),
                        ),
                      ),

                      // Center Play Button
                      Center(
                        child: AnimatedOpacity(
                          opacity: _isHovered ? 1.0 : 0.85,
                          duration: const Duration(milliseconds: 150),
                          child: Tooltip(
                            message: 'Continue Watching ${widget.movie.title}',
                            child: InkWell(
                              onTap: widget.onPlay,
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed.withValues(
                                    alpha: 0.9,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Dismiss / Remove button (top right)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Tooltip(
                          message: 'Remove from Continue Watching',
                          child: InkWell(
                            onTap: widget.onRemove,
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Linear Progress Indicator
                LinearProgressIndicator(
                  value: widget.progress,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryRed,
                  ),
                  minHeight: 3.5,
                ),

                // Bottom Metadata Info
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.movie.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Demo: $percent% watched',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
