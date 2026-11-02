import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';

/// ProfileDialog displays the user's profile with real saved movie counts,
/// real recently viewed counts, viewing history clearing with confirmation,
/// and an About FlixGo section without fake subscription claims.
class ProfileDialog extends StatelessWidget {
  final int savedCount;
  final int recentlyViewedCount;
  final VoidCallback onClearHistory;

  const ProfileDialog({
    super.key,
    required this.savedCount,
    this.recentlyViewedCount = 0,
    required this.onClearHistory,
  });

  static Future<void> show(
    BuildContext context, {
    required int savedCount,
    int recentlyViewedCount = 0,
    required VoidCallback onClearHistory,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ProfileDialog(
        savedCount: savedCount,
        recentlyViewedCount: recentlyViewedCount,
        onClearHistory: onClearHistory,
      ),
    );
  }

  void _showClearHistoryConfirmation(BuildContext context) {
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
          'This will permanently remove all titles from your recently viewed history and continue-watching list. This action cannot be undone.',
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
              Navigator.of(context).pop();
              onClearHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Viewing history and continue-watching list cleared.',
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
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

  void _showAboutDialog(BuildContext context) {
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
              Icons.movie_creation_rounded,
              color: AppColors.primaryRed,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              'About FlixGo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FlixGo Streaming Client',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Version 1.0.0+1 • Production Ready',
              style: TextStyle(
                color: AppColors.primaryRed,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'FlixGo is an open-source cinematic streaming demonstration built with Flutter & Dart. It showcases modern responsive UI design, embedded YouTube iFrame trailer playback, and persistent local storage.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.surfaceBorder),
            const SizedBox(height: 8),
            _buildTechRow('Framework', 'Flutter 3.x (Material 3)'),
            _buildTechRow('Language', 'Dart 3.x'),
            _buildTechRow('Trailer Engine', 'youtube_player_iframe 6.x'),
            _buildTechRow(
              'Local Storage',
              'shared_preferences (Cross-platform)',
            ),
            _buildTechRow('Platforms', 'Web, Android, iOS, Desktop'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceLight,
              foregroundColor: Colors.white,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  static Widget _buildTechRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 24 : 32,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceBorder, width: 0.8),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440, maxHeight: 680),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryRed, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.surfaceLight,
                    child: Icon(Icons.person, size: 42, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),

                // Name & Email
                const Text(
                  'Harish',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'harish@flixgo.dev',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),

                // Honest Open Showcase Badge (Replaces fake VIP subscription)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryRed.withValues(alpha: 0.5),
                      width: 0.8,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.primaryRed,
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'OPEN CATALOG • FREE DEMO STREAMING',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Divider(color: AppColors.surfaceBorder),
                const SizedBox(height: 12),

                // Real Quick Stats (Requirement: Feature 4)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem('Saved', '$savedCount'),
                    _statItem('Viewed', '$recentlyViewedCount'),
                    _statItem('Quality', '4K / HD'),
                  ],
                ),
                const SizedBox(height: 20),

                // Option: Clear Viewing History
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.delete_sweep_outlined,
                    color: AppColors.primaryRed,
                    size: 20,
                  ),
                  title: const Text(
                    'Clear Viewing History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    recentlyViewedCount > 0
                        ? '$recentlyViewedCount recently viewed titles'
                        : 'History is empty',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                  onTap: recentlyViewedCount > 0
                      ? () => _showClearHistoryConfirmation(context)
                      : null,
                ),

                // Option: About FlixGo
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  title: const Text(
                    'About FlixGo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Version 1.0.0+1 • Technology Stack',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                  onTap: () => _showAboutDialog(context),
                ),

                // Option: Playback Quality
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  title: const Text(
                    'Playback Preferences',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Hardware acceleration enabled • Auto quality',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                  trailing: const Icon(
                    Icons.check_rounded,
                    color: AppColors.greenTag,
                    size: 18,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Playback is optimized for your screen resolution.',
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Close Action
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.surfaceBorder),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }
}
