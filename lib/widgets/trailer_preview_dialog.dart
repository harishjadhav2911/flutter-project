import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../models/movie.dart';
import 'network_movie_image.dart';

/// TrailerPlayerDialog (aliased as TrailerPreviewDialog for backward compatibility)
/// provides actual YouTube trailer playback across Web and Android, with full-screen
/// support, custom controls, loading/error states, and graceful fallback handling.
class TrailerPreviewDialog extends StatefulWidget {
  final Movie movie;

  const TrailerPreviewDialog({super.key, required this.movie});

  /// Static helper to display the responsive trailer dialog.
  static Future<void> show(BuildContext context, Movie movie) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (context) => TrailerPreviewDialog(movie: movie),
    );
  }

  @override
  State<TrailerPreviewDialog> createState() => _TrailerPreviewDialogState();
}

/// Type alias for semantic clarity when creating new code.
typedef TrailerPlayerDialog = TrailerPreviewDialog;

class _TrailerPreviewDialogState extends State<TrailerPreviewDialog> {
  YoutubePlayerController? _controller;
  StreamSubscription<YoutubePlayerValue>? _controllerSubscription;

  bool _isPlayerReady = false;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isPlaying = true;
  bool _isMuted = false;
  bool _isFullScreen = false;

  /// Determines whether the current environment supports embedded WebViews.
  /// On Web (kIsWeb) and Android/iOS, this returns true.
  /// In automated headless flutter tests or unsupported desktop shells,
  /// returns false to prevent platform channel exceptions.
  bool get _canUseEmbeddedPlayer {
    if (kIsWeb) return true;
    final bindingName = WidgetsBinding.instance.runtimeType.toString();
    if (bindingName.contains('Test')) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    final videoId = widget.movie.youtubeVideoId;
    if (videoId == null || videoId.isEmpty) {
      _isLoading = false;
      _hasError = false;
      return;
    }

    if (_canUseEmbeddedPlayer) {
      try {
        _controller = YoutubePlayerController.fromVideoId(
          videoId: videoId,
          autoPlay: true,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
            mute: false,
            enableCaption: true,
            showVideoAnnotations: false,
            strictRelatedVideos: true,
          ),
        );

        _controllerSubscription = _controller!.listen((value) {
          if (!mounted) return;
          setState(() {
            if (value.playerState == PlayerState.playing) {
              _isPlaying = true;
              _isLoading = false;
              _isPlayerReady = true;
            } else if (value.playerState == PlayerState.paused) {
              _isPlaying = false;
              _isLoading = false;
              _isPlayerReady = true;
            } else if (value.playerState == PlayerState.buffering) {
              _isLoading = true;
            } else if (value.playerState == PlayerState.cued) {
              _isLoading = false;
              _isPlayerReady = true;
            }

            if (value.hasError) {
              _hasError = true;
              _isLoading = false;
              _errorMessage = 'Unable to stream trailer (${value.error.name}).';
            }
          });
        });
      } catch (e) {
        _hasError = true;
        _isLoading = false;
        _errorMessage = 'Player initialization failed: $e';
      }
    } else {
      // Test environment or fallback desktop mode
      _isLoading = false;
      _isPlayerReady = true;
    }
  }

  @override
  void dispose() {
    _controllerSubscription?.cancel();
    _controller?.close();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller != null && _isPlayerReady) {
      if (_isPlaying) {
        _controller!.pauseVideo();
      } else {
        _controller!.playVideo();
      }
    }
    if (mounted) {
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }

  void _toggleMute() {
    if (_controller != null && _isPlayerReady) {
      if (_isMuted) {
        _controller!.unMute();
      } else {
        _controller!.mute();
      }
    }
    if (mounted) {
      setState(() {
        _isMuted = !_isMuted;
      });
    }
  }

  void _toggleFullScreen() {
    if (_controller != null && _isPlayerReady) {
      _controller!.toggleFullScreen();
    }
    if (mounted) {
      setState(() {
        _isFullScreen = !_isFullScreen;
      });
    }
  }

  Future<void> _openInYouTube() async {
    final watchUrl = widget.movie.youtubeWatchUrl;
    if (watchUrl == null) return;
    final uri = Uri.parse(watchUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      // Graceful fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final String trailerTitle = widget.movie.trailerTitle.isNotEmpty
        ? widget.movie.trailerTitle
        : '${widget.movie.title} — Official Trailer';

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceBorder, width: 0.8),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 16 : 32,
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 860,
          maxHeight:
              MediaQuery.sizeOf(context).height * (isMobile ? 0.94 : 0.90),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Bar
              _buildHeader(trailerTitle),

              // Video Player Area
              if (!widget.movie.hasTrailer)
                _buildUnavailableState()
              else if (_hasError)
                _buildErrorState()
              else if (_canUseEmbeddedPlayer && _controller != null)
                _buildEmbeddedPlayer()
              else
                _buildFallbackPlayer(),

              // Control & Info Footer
              _buildFooter(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  /// Dialog Header with Title, Badges, and Close Button
  Widget _buildHeader(String trailerTitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceBorder, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.play_circle_filled_rounded,
                  color: Colors.white,
                  size: 14,
                ),
                SizedBox(width: 4),
                Text(
                  'TRAILER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              trailerTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.close_rounded,
              size: 20,
              color: Colors.white,
            ),
            tooltip: 'Close Trailer',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// Actual Embedded YouTube Iframe Player
  Widget _buildEmbeddedPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          YoutubePlayer(controller: _controller!, aspectRatio: 16 / 9),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.8),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.primaryRed,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Loading Official Trailer...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Fallback & Test Player View (used when embedded webview platform is unavailable)
  Widget _buildFallbackPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
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
          Container(
            color: Colors.black.withValues(alpha: _isPlaying ? 0.35 : 0.65),
          ),
          // Big Center Play Indicator if paused
          if (!_isPlaying)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRed.withValues(alpha: 0.4),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          // Tap frame to toggle play/pause
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _togglePlayPause,
          ),
        ],
      ),
    );
  }

  /// State when trailer is unavailable
  Widget _buildUnavailableState() {
    return Container(
      constraints: const BoxConstraints(minHeight: 280),
      color: AppColors.surfaceLight,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: const Icon(
                  Icons.videocam_off_rounded,
                  size: 40,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Trailer Unavailable',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(
                  'An official trailer has not been configured or is temporarily unavailable for "${widget.movie.title}".',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, size: 16),
                label: const Text('Close'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.surfaceBorder),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Error State with Retry and External Watch Fallback
  Widget _buildErrorState() {
    return Container(
      constraints: const BoxConstraints(minHeight: 280),
      color: AppColors.surfaceLight,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: AppColors.primaryRed,
              ),
              const SizedBox(height: 14),
              const Text(
                'Playback Error',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _errorMessage.isNotEmpty
                    ? _errorMessage
                    : 'The YouTube player was unable to stream this video.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _isLoading = true;
                      });
                      _initializePlayer();
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  if (widget.movie.youtubeWatchUrl != null)
                    OutlinedButton.icon(
                      onPressed: _openInYouTube,
                      icon: const Icon(Icons.open_in_new_rounded, size: 16),
                      label: const Text('Watch on YouTube'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: AppColors.surfaceBorder),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Dialog Controls & Metadata Footer
  Widget _buildFooter(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.surface,
      child: Row(
        children: [
          // Play / Pause Button
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
            ),
            tooltip: _isPlaying ? 'Pause' : 'Play',
            onPressed: _togglePlayPause,
          ),

          // Mute Button
          IconButton(
            icon: Icon(
              _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
              color: Colors.white,
            ),
            tooltip: _isMuted ? 'Unmute' : 'Mute',
            onPressed: _toggleMute,
          ),

          // Fullscreen Button
          IconButton(
            icon: Icon(
              _isFullScreen
                  ? Icons.fullscreen_exit_rounded
                  : Icons.fullscreen_rounded,
              color: Colors.white,
            ),
            tooltip: 'Fullscreen',
            onPressed: _toggleFullScreen,
          ),

          const SizedBox(width: 8),

          // Movie Metadata Info
          if (!isMobile)
            Expanded(
              child: Text(
                '${widget.movie.releaseYear} • ${widget.movie.duration} • ${widget.movie.genres.join(", ")}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            )
          else
            const Spacer(),

          // Open directly on YouTube
          if (widget.movie.youtubeWatchUrl != null)
            TextButton.icon(
              onPressed: _openInYouTube,
              icon: const Icon(
                Icons.open_in_new_rounded,
                size: 14,
                color: AppColors.textSecondary,
              ),
              label: const Text(
                'YouTube',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
