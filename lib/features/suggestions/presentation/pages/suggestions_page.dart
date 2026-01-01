// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/insight.dart';
import 'package:intl/intl.dart';
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
              const Expanded(child: Center(child: CircularProgressIndicator()))
            /// Nếu lỗi + chưa có data
            else if (state.errorMessage != null && state.insights.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    "Error: ${state.errorMessage}",
                    style: TextStyle(color: AppColors.bgError, fontSize: 16.sp),
                  ),
                ),
              )
            /// DANH SÁCH GỢI Ý
            else
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: () => notifier.onTapDetail(context, insight),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 14.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.bgWhite,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: style.bgColor.withOpacity(0.22)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 6),
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4.w,
                height: 88.h,
                decoration: BoxDecoration(
                  color: style.bgColor,
                  borderRadius: BorderRadius.circular(99.r),
                ),
              ),
              SizedBox(width: 12.w),
              // ICON
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      style.bgColor.withOpacity(0.2),
                      style.bgColor.withOpacity(0.35),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(style.icon, color: style.bgColor, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              // TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: style.bgColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            style.label,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w700,
                              color: style.bgColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _formatTime(insight.createdAt),
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            color: AppColors.typoBody,
                          ),
                        ),
                        const Spacer(),
                        if (!insight.read)
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: style.bgColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      insight.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.typoHeading,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      insight.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        color: AppColors.typoBody,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: style.bgColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: style.bgColor,
                ),
              ),
            ],
          ),
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
          bgColor: Colors.amber.shade400,
          label: "Cảnh báo",
        );

      case "tip":
        return _InsightStyle(
          icon: Icons.lightbulb_outline,
          bgColor: Colors.lightGreen.shade400,
          label: "Mẹo hay",
        );

      case "budget_alert":
        return _InsightStyle(
          icon: Icons.account_balance_wallet_outlined,
          bgColor: Colors.orange.shade400,
          label: "Ngân sách",
        );

      case "monthly_summary":
        return _InsightStyle(
          icon: Icons.stacked_line_chart,
          bgColor: Colors.lightBlue.shade400,
          label: "Tổng kết",
        );

      case "daily_report":
        return _InsightStyle(
          icon: Icons.show_chart,
          bgColor: Colors.lightBlue.shade400,
          label: "Hằng ngày",
        );

      case "monthly_report":
        return _InsightStyle(
          icon: Icons.monitor_heart_outlined,
          bgColor: Colors.lightBlue.shade400,
          label: "Tháng",
        );

      default:
        return _InsightStyle(
          icon: Icons.info_outline,
          bgColor: AppColors.bgDarkGreen,
          label: "Thông tin",
        );
    }
  }

  String _formatTime(int createdAt) {
    final dt = DateTime.fromMillisecondsSinceEpoch(createdAt);
    return DateFormat('dd/MM • HH:mm').format(dt);
  }
}

/// Helper style class
class _InsightStyle {
  final IconData icon;
  final Color bgColor;
  final String label;

  _InsightStyle({
    required this.icon,
    required this.bgColor,
    required this.label,
  });
}
