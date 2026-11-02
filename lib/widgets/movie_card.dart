import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/movie.dart';
import 'network_movie_image.dart';

/// MovieCard displays a rounded movie poster with title, rating,
/// quality badge, hover scale, and a quick "My List" bookmark button.
class MovieCard extends StatefulWidget {
  final Movie movie;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavorite;
  final double width;
  final double height;

  const MovieCard({
    super.key,
    required this.movie,
    this.isFavorite = false,
    this.onTap,
    this.onToggleFavorite,
    this.width = 160,
    this.height = 240,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.primaryRed.withValues(alpha: 0.35),
                        blurRadius: 18,
                        spreadRadius: 1,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Poster Image
                  NetworkMovieImage(
                    imageUrl: widget.movie.posterUrl,
                    fallbackTitle: widget.movie.title,
                    fit: BoxFit.cover,
                  ),

                  // Bottom Gradient Overlay for readability
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: AppColors.cardOverlay,
                      ),
                    ),
                  ),

                  // Quality Tag (Top Left)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.surfaceBorder,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        widget.movie.quality.contains('4K') ? '4K' : 'HD',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  // Quick Favorite Button (Top Right)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onToggleFavorite,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.isFavorite
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: widget.isFavorite
                                ? AppColors.primaryRed
                                : Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Movie Info (Bottom)
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: 8,
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
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              '${widget.movie.releaseYear}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.starGold,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              widget.movie.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
