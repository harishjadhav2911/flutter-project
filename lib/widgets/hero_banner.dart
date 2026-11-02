import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../models/movie.dart';
import 'network_movie_image.dart';

/// HeroBanner displays a cinematic full-width featured movie banner
/// with gradient overlays, metadata badges, and interactive action buttons.
class HeroBanner extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;
  final VoidCallback onPlayTrailer;
  final VoidCallback onToggleFavorite;
  final VoidCallback onMoreInfo;

  const HeroBanner({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.onPlayTrailer,
    required this.onToggleFavorite,
    required this.onMoreInfo,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double bannerHeight = isMobile ? 420 : 540;
    final double horizontalPadding = isMobile ? 16 : 36;

    return SizedBox(
      height: bannerHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Backdrop Image
          NetworkMovieImage(
            imageUrl: movie.backdropUrl.isNotEmpty
                ? movie.backdropUrl
                : movie.posterUrl,
            fallbackTitle: movie.title,
            fit: BoxFit.cover,
          ),

          // Horizontal Vignette (Left to Right dark overlay for legibility on desktop)
          if (!isMobile)
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: AppColors.horizontalVignette,
                ),
              ),
            ),

          // Vertical Vignette (Fades smoothly into body background #09090D)
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
            ),
          ),

          // Banner Content
          Positioned(
            left: horizontalPadding,
            right: isMobile ? horizontalPadding : 180,
            bottom: isMobile ? 24 : 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // "FLIXGO FEATURED" Tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.movie_creation_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'FLIXGO SPOTLIGHT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Movie Title
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 26 : 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    height: 1.1,
                    shadows: const [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 16,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Metadata Chips: Rating, Year, Quality, Age
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.starGold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.starGold,
                          width: 0.8,
                        ),
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
                    _badge('${movie.releaseYear}'),
                    _badge(movie.ageRating),
                    _badge(movie.quality, isHighlight: true),
                    Text(
                      movie.duration,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Genres
                Text(
                  movie.genres.join(' • '),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),

                // Overview Synopsis
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Text(
                    movie.overview,
                    maxLines: isMobile ? 3 : 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: isMobile ? 13 : 14.5,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Action Buttons
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    // Play Trailer Button
                    ElevatedButton.icon(
                      onPressed: onPlayTrailer,
                      icon: const Icon(Icons.play_arrow_rounded, size: 22),
                      label: const Text('Play Trailer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 22,
                          vertical: isMobile ? 10 : 13,
                        ),
                      ),
                    ),

                    // My List Button
                    OutlinedButton.icon(
                      onPressed: onToggleFavorite,
                      icon: Icon(
                        isFavorite ? Icons.check_rounded : Icons.add_rounded,
                        size: 20,
                        color: isFavorite ? AppColors.greenTag : Colors.white,
                      ),
                      label: Text(
                        isFavorite ? 'In My List' : 'My List',
                        style: TextStyle(
                          color: isFavorite ? AppColors.greenTag : Colors.white,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.45),
                        side: BorderSide(
                          color: isFavorite
                              ? AppColors.greenTag
                              : AppColors.textSecondary,
                          width: 1.2,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 14 : 20,
                          vertical: isMobile ? 10 : 13,
                        ),
                      ),
                    ),

                    // More Info Button
                    IconButton(
                      onPressed: onMoreInfo,
                      tooltip: 'More Information',
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surfaceLight.withValues(
                          alpha: 0.6,
                        ),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(10),
                      ),
                      icon: const Icon(Icons.info_outline_rounded, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isHighlight
            ? AppColors.primaryRed.withValues(alpha: 0.25)
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isHighlight
              ? AppColors.primaryRed.withValues(alpha: 0.6)
              : AppColors.surfaceBorder,
          width: 0.6,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isHighlight ? AppColors.primaryRed : Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
