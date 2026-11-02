import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../models/movie.dart';
import 'network_movie_image.dart';

/// MovieDetailsDialog shows full movie information, cast, director,
/// synopsis, trailer player trigger, and My List toggle.
class MovieDetailsDialog extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onPlayTrailer;

  const MovieDetailsDialog({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onPlayTrailer,
  });

  static Future<void> show(
    BuildContext context, {
    required Movie movie,
    required bool isFavorite,
    required VoidCallback onToggleFavorite,
    required VoidCallback onPlayTrailer,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => MovieDetailsDialog(
        movie: movie,
        isFavorite: isFavorite,
        onToggleFavorite: onToggleFavorite,
        onPlayTrailer: onPlayTrailer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 40,
        vertical: isMobile ? 24 : 40,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceBorder, width: 0.8),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 720,
          maxHeight:
              MediaQuery.sizeOf(context).height * (isMobile ? 0.92 : 0.88),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Backdrop Banner
              Stack(
                children: [
                  NetworkMovieImage(
                    imageUrl: movie.backdropUrl.isNotEmpty
                        ? movie.backdropUrl
                        : movie.posterUrl,
                    fallbackTitle: movie.title,
                    width: double.infinity,
                    height: isMobile ? 220 : 300,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: AppColors.heroGradient,
                      ),
                    ),
                  ),
                  // Close Button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.7),
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  // Title and Quick Metadata on Header
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 22 : 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.starGold.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: AppColors.starGold,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    movie.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: AppColors.starGold,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${movie.releaseYear} • ${movie.duration}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Body Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Action Buttons Row
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              onPlayTrailer();
                            });
                          },
                          icon: const Icon(Icons.play_arrow_rounded, size: 22),
                          label: Text(
                            movie.hasTrailer
                                ? 'Play Trailer'
                                : 'Trailer Unavailable',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: movie.hasTrailer
                                ? AppColors.primaryRed
                                : AppColors.surfaceLight,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: onToggleFavorite,
                          icon: Icon(
                            isFavorite
                                ? Icons.check_rounded
                                : Icons.bookmark_add_outlined,
                            size: 18,
                            color: isFavorite
                                ? AppColors.greenTag
                                : Colors.white,
                          ),
                          label: Text(
                            isFavorite ? 'Saved to My List' : 'Add to My List',
                            style: TextStyle(
                              color: isFavorite
                                  ? AppColors.greenTag
                                  : Colors.white,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isFavorite
                                  ? AppColors.greenTag
                                  : AppColors.surfaceBorder,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Genres
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: movie.genres.map((genre) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.surfaceBorder,
                              width: 0.6,
                            ),
                          ),
                          child: Text(
                            genre,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Synopsis
                    const Text(
                      'Overview',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Divider(color: AppColors.surfaceBorder),
                    const SizedBox(height: 14),

                    // Director & Cast Details
                    if (movie.director.isNotEmpty) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text(
                              'Director:',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              movie.director,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],

                    if (movie.cast.isNotEmpty) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text(
                              'Cast:',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              movie.cast.join(', '),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
