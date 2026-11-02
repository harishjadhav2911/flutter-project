import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';

/// FlixgoAppBar is a responsive navigation bar for desktop, tablet, and mobile.
class FlixgoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedTabIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;
  final String searchQuery;
  final ValueChanged<String>? onSearchChanged;
  final bool isSearchActive;
  final VoidCallback? onCloseSearch;

  const FlixgoAppBar({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
    required this.onSearchTap,
    required this.onProfileTap,
    this.searchQuery = '',
    this.onSearchChanged,
    this.isSearchActive = false,
    this.onCloseSearch,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double horizontalPadding = isMobile ? 16 : 36;

    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.92),
        border: const Border(
          bottom: BorderSide(color: AppColors.surfaceBorder, width: 0.6),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: isSearchActive
          ? _buildActiveSearchBar(context)
          : Row(
              children: [
                // FlixGo Logo
                _buildLogo(context),

                // Desktop / Tablet Navigation Links
                if (!isMobile) ...[
                  const SizedBox(width: 32),
                  _navLink('Home', 0),
                  _navLink('Movies', 1),
                  _navLink('Series', 2),
                  _navLink('Search', 3),
                  _navLink('My List', 4),
                ],

                const Spacer(),

                // Search Icon
                IconButton(
                  tooltip: 'Search Movies & Genres',
                  icon: const Icon(Icons.search_rounded),
                  color: Colors.white,
                  onPressed: onSearchTap,
                ),

                const SizedBox(width: 4),

                // Notifications
                if (!isMobile)
                  IconButton(
                    tooltip: 'Notifications',
                    icon: const Badge(
                      label: Text('2'),
                      backgroundColor: AppColors.primaryRed,
                      child: Icon(Icons.notifications_none_rounded),
                    ),
                    color: Colors.white,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No new notifications right now.'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),

                const SizedBox(width: 8),

                // User Profile Avatar
                InkWell(
                  onTap: onProfileTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryRed,
                        width: 1.5,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.surfaceLight,
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return InkWell(
      onTap: () => onTabSelected(0),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Text.rich(
              const TextSpan(
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
                children: [
                  TextSpan(
                    text: 'FLIX',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: 'GO',
                    style: TextStyle(color: AppColors.primaryRed),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navLink(String label, int tabIndex) {
    final bool isSelected = selectedTabIndex == tabIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () => onTabSelected(tabIndex),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2.5,
                width: isSelected ? 22 : 0,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSearchBar(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.search_rounded, color: AppColors.primaryRed),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText:
                  'Search by title, director, or genre (e.g. Sci-Fi, Nolan)...',
              hintStyle: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
              border: InputBorder.none,
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: AppColors.textMuted,
                        size: 18,
                      ),
                      onPressed: () => onSearchChanged?.call(''),
                    )
                  : null,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Close Search',
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: onCloseSearch,
        ),
      ],
    );
  }
}
