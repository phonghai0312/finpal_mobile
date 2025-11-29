// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:fridge_to_fork_ai/features/suggestions/presentation/provider/suggestion_provider.dart';
import 'package:collection/collection.dart';

class SuggestionsPage extends ConsumerWidget {
  const SuggestionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionsState = ref.watch(suggestionsNotifierProvider);
    final notifier = ref.read(suggestionsNotifierProvider.notifier);

    // Fetch insights when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.fetchInsights();
    });

    if (suggestionsState.isLoading && suggestionsState.insights.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (suggestionsState.error != null && suggestionsState.insights.isEmpty) {
      return Scaffold(
        body: Center(child: Text('Error: ${suggestionsState.error}')),
      );
    }

    // Filter insights for the top two cards
    final alertInsight = suggestionsState.insights.firstWhereOrNull(
      (e) => e.type == 'alert',
    );
    final autoAnalysisInsight = suggestionsState.insights.firstWhereOrNull(
      (e) => e.type == 'tip' && e.title == 'Phân tích tự động',
    );

    // Filter insights for other cards
    final otherInsights = suggestionsState.insights
        .where(
          (e) =>
              e.type != 'alert' &&
              !(e.type == 'tip' && e.title == 'Phân tích tự động'),
        )
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.bgWhite,
        elevation: 0,
        title: Text(
          'Gợi ý tài chính',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.typoHeading,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (alertInsight != null)
                  Expanded(
                    child: _buildSuggestionCard(
                      context,
                      icon: Icons.warning_amber_rounded,
                      iconColor: AppColors.bgWarning,
                      title: alertInsight.title,
                      description: alertInsight.message,
                      buttonText: 'Xem chi tiết & đặt hạn mức',
                      onTap: () => context.push(
                        '${AppRoutes.suggestionDetail}/${alertInsight.id}',
                      ),
                      // ignore: deprecated_member_use
                      cardColor: AppColors.bgWarning.withOpacity(0.1),
                    ),
                  ),
                if (alertInsight != null &&
                    autoAnalysisInsight !=
                        null) // Add spacing only if both exist
                  SizedBox(width: 16.w),
                if (autoAnalysisInsight != null)
                  Expanded(
                    child: _buildSuggestionCard(
                      context,
                      icon: Icons.lightbulb_outline,
                      iconColor: AppColors.primaryGreen,
                      title: autoAnalysisInsight.title,
                      description: autoAnalysisInsight.message,
                      buttonText: 'Xem chi tiết',
                      onTap: () => context.push(
                        '${AppRoutes.suggestionDetail}/${autoAnalysisInsight.id}',
                      ),
                      cardColor: AppColors.primaryGreen.withOpacity(0.1),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              'Các gợi ý khác',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.typoHeading,
              ),
            ),
            SizedBox(height: 16.h),
            ...otherInsights.map((insight) {
              IconData icon;
              Color iconColor;
              Color cardColor;
              switch (insight.type) {
                case 'monthly_summary':
                  icon = Icons.arrow_upward_rounded;
                  iconColor = AppColors.primaryGreen;
                  // ignore: deprecated_member_use
                  cardColor = AppColors.primaryGreen.withOpacity(0.1);
                  break;
                case 'budget_alert':
                  icon = Icons.money;
                  iconColor = AppColors.typoPrimary;
                  cardColor = AppColors.lightRed.withOpacity(0.1);
                  break;
                case 'tip':
                  icon = Icons.emoji_objects_outlined;
                  iconColor = AppColors.lightRed;
                  cardColor = AppColors.lightRed.withOpacity(0.1);
                  break;
                default:
                  icon = Icons.info_outline;
                  iconColor = AppColors.typoBody;
                  // ignore: deprecated_member_use
                  cardColor = AppColors.bgGray.withOpacity(0.1);
              }
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildLargeSuggestionCard(
                  context,
                  icon: icon,
                  iconColor: iconColor,
                  title: insight.title,
                  description: insight.message,
                  onTap: () => context.push(
                    '${AppRoutes.suggestionDetail}/${insight.id}',
                  ),
                  cardColor: cardColor,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onTap,
    required Color cardColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        // ignore: deprecated_member_use
        border: Border.all(color: iconColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 30.sp),
          SizedBox(height: 8.h),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.typoHeading,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.typoBody),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: onTap,
            child: Text(
              buttonText,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: iconColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeSuggestionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
    required Color cardColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: iconColor.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 36.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.typoHeading,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.typoBody),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: onTap,
            child: Text(
              'Xem chi tiết',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: iconColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
