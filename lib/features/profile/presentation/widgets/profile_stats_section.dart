/// Profile Stats Section Widget
/// 
/// Section displaying user statistics/achievements.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Profile stats section
class ProfileStatsSection extends StatelessWidget {
  /// List of stats to display
  final List<ProfileStatData> stats;
  
  /// Section title
  final String? title;

  const ProfileStatsSection({
    super.key,
    required this.stats,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                title!,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkDivider : AppColors.grey200,
              ),
            ),
            child: Row(
              children: stats.asMap().entries.map((entry) {
                final index = entry.key;
                final stat = entry.value;
                
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: index < stats.length - 1
                          ? Border(
                              right: BorderSide(
                                color: isDark
                                    ? AppColors.darkDivider
                                    : AppColors.grey200,
                              ),
                            )
                          : null,
                    ),
                    child: _StatItem(stat: stat),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final ProfileStatData stat;

  const _StatItem({required this.stat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: stat.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Text(
            stat.value,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: stat.valueColor ?? AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Data class for profile stat
class ProfileStatData {
  /// Stat value
  final String value;
  
  /// Stat label
  final String label;
  
  /// Optional value color
  final Color? valueColor;
  
  /// Optional tap callback
  final VoidCallback? onTap;

  const ProfileStatData({
    required this.value,
    required this.label,
    this.valueColor,
    this.onTap,
  });
}

/// Profile info cards (horizontal scrollable)
class ProfileInfoCards extends StatelessWidget {
  /// List of info cards
  final List<ProfileInfoCardData> cards;

  const ProfileInfoCards({
    super.key,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return _InfoCard(data: cards[index]);
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final ProfileInfoCardData data;

  const _InfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: data.onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              data.color,
              data.color.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: data.color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              data.icon,
              color: Colors.white,
              size: 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.value,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Data class for profile info card
class ProfileInfoCardData {
  /// Card icon
  final IconData icon;
  
  /// Card value
  final String value;
  
  /// Card label
  final String label;
  
  /// Card color
  final Color color;
  
  /// Optional tap callback
  final VoidCallback? onTap;

  const ProfileInfoCardData({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.onTap,
  });
}

/// Member since badge
class MemberSinceBadge extends StatelessWidget {
  /// Join date
  final DateTime joinDate;

  const MemberSinceBadge({
    super.key,
    required this.joinDate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.grey100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 14,
            color: AppColors.grey500,
          ),
          const SizedBox(width: 6),
          Text(
            'Member since ${_formatDate(joinDate)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}