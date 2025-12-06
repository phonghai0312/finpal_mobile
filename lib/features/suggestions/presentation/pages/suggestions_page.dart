// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/insight.dart';
import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/header/header_simple.dart';
import 'package:fridge_to_fork_ai/features/suggestions/presentation/provider/insight/insight_provider.dart';

class SuggestionsPage extends ConsumerStatefulWidget {
  const SuggestionsPage({super.key});

  @override
  ConsumerState<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends ConsumerState<SuggestionsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(insightsNotifierProvider.notifier).init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(insightsNotifierProvider);
    final notifier = ref.read(insightsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: const HeaderSimple(title: "Gợi ý tài chính"),

      body: RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: () async => notifier.refresh(context),

        child: Column(
          children: [
            /// Nếu loading + chưa có data
            if (state.isLoading && state.insights.isEmpty)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )

            /// Nếu lỗi + chưa có data
            else if (state.errorMessage != null && state.insights.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    "Error: ${state.errorMessage}",
                    style:
                        TextStyle(color: AppColors.bgError, fontSize: 16.sp),
                  ),
                ),
              )

            /// DANH SÁCH GỢI Ý
            else
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  itemCount: state.insights.length,
                  itemBuilder: (_, i) {
                    final insight = state.insights[i];
                    return _buildInsightCard(context, ref, insight);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// ================================
  /// CARD UI (theo style ProfilePage)
  /// ================================
  Widget _buildInsightCard(
    BuildContext context,
    WidgetRef ref,
    Insight insight,
  ) {
    final notifier = ref.read(insightsNotifierProvider.notifier);
    final style = _mapInsightType(insight.type);

    return GestureDetector(
      onTap: () => notifier.onTapDetail(context, insight),

      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.bgGray.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ICON
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: style.bgColor.withOpacity(.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                style.icon,
                color: style.bgColor,
                size: 26.sp,
              ),
            ),

            SizedBox(width: 14.w),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.title,
                    style: TextStyle(
                      fontSize: 15.5.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.typoHeading,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  Text(
                    insight.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      color: AppColors.typoBody,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppColors.typoBody,
            ),
          ],
        ),
      ),
    );
  }

  /// ================================
  /// TYPE → ICON + COLOR
  /// ================================
  _InsightStyle _mapInsightType(String type) {
    switch (type) {
      case "alert":
        return _InsightStyle(
          icon: Icons.warning_amber_rounded,
          bgColor: AppColors.lightRed,
        );

      case "tip":
        return _InsightStyle(
          icon: Icons.lightbulb_outline,
          bgColor: AppColors.primaryGreen,
        );

      case "budget_alert":
        return _InsightStyle(
          icon: Icons.account_balance_wallet_outlined,
          bgColor: Colors.orange,
        );

      case "monthly_summary":
        return _InsightStyle(
          icon: Icons.stacked_line_chart,
          bgColor: Colors.blue,
        );

      case "daily_report":
        return _InsightStyle(
          icon: Icons.show_chart,
          bgColor: Colors.cyan,
        );

      case "monthly_report":
        return _InsightStyle(
          icon: Icons.monitor_heart_outlined,
          bgColor: Colors.indigo,
        );

      default:
        return _InsightStyle(
          icon: Icons.info_outline,
          bgColor: AppColors.bgDarkGreen,
        );
    }
  }
}

/// Helper style class
class _InsightStyle {
  final IconData icon;
  final Color bgColor;

  _InsightStyle({required this.icon, required this.bgColor});
}
