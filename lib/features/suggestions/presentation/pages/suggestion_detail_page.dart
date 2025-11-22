import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/features/suggestions/presentation/provider/suggestion_provider.dart';
import 'package:go_router/go_router.dart';

class SuggestionDetailPage extends ConsumerWidget {
  final String insightId;

  const SuggestionDetailPage({super.key, required this.insightId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionDetailState = ref.watch(
      suggestionDetailNotifierProvider(insightId),
    );
    final notifier = ref.read(
      suggestionDetailNotifierProvider(insightId).notifier,
    );

    if (suggestionDetailState.insight == null &&
        suggestionDetailState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (suggestionDetailState.insight == null &&
        suggestionDetailState.error != null) {
      return Scaffold(
        body: Center(child: Text('Error: ${suggestionDetailState.error}')),
      );
    }

    if (suggestionDetailState.insight == null) {
      return const Scaffold(body: Center(child: Text('Insight not found')));
    }

    final insight = suggestionDetailState.insight!;

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.bgWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.typoHeading,
            size: 24.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Chi tiết gợi ý',
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
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.bgWhite,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.bgGray.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.typoHeading,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    insight.message,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.typoBody),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            if (suggestionDetailState.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (suggestionDetailState.error != null)
              Text(
                'Error: ${suggestionDetailState.error}',
                style: TextStyle(color: AppColors.bgError),
              )
            else
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async {
                    await notifier.markAsRead();
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 24.w,
                    ),
                    elevation: 4,
                    shadowColor: AppColors.primaryGreen.withOpacity(0.3),
                  ),
                  child: Text(
                    'Đánh dấu đã đọc',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.typoWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
