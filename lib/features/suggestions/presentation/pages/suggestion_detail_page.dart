// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/suggestions/presentation/provider/insight_detail/insight_detail_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/header/header_with_back.dart';

class SuggestionDetailPage extends ConsumerStatefulWidget {
  const SuggestionDetailPage({super.key});

  @override
  ConsumerState<SuggestionDetailPage> createState() =>
      _SuggestionDetailPageState();
}

class _SuggestionDetailPageState extends ConsumerState<SuggestionDetailPage> {
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_init) {
      _init = true;
      Future.microtask(() {
        ref.read(insightDetailNotifierProvider.notifier).init(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(insightDetailNotifierProvider);
    final notifier = ref.read(insightDetailNotifierProvider.notifier);

    final insight = state.insight;
    if (insight == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    /// Get style theo type
    final typeUI = notifier.getDesign(insight.type);
    final Color typeColor = typeUI["color"];
    final IconData typeIcon = typeUI["icon"];

    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      appBar: HeaderWithBack(
        title: "Insight Detail",
        onBack: () => notifier.onBack(context),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===============================
            ///  TYPE SECTION
            /// ===============================
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(.12),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: typeColor.withOpacity(.4)),
              ),
              child: Row(
                children: [
                  Icon(typeIcon, color: typeColor, size: 30.sp),
                  SizedBox(width: 12.w),

                  Expanded(
                    child: Text(
                      insight.type.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.typoHeading,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            /// ===============================
            ///  TITLE
            /// ===============================
            Text(
              insight.title,
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.typoHeading,
              ),
            ),

            SizedBox(height: 12.h),

            /// ===============================
            ///  MESSAGE BOX
            /// ===============================
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.bgHover,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.bgGray.withOpacity(.3)),
              ),
              child: Text(
                insight.message,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  height: 1.4,
                  color: AppColors.typoBody,
                ),
              ),
            ),

            SizedBox(height: 28.h),

            /// ===============================
            /// PERIOD
            /// ===============================
            Text(
              "Period",
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoHeading,
              ),
            ),

            SizedBox(height: 10.h),

            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.bgWhite,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.bgGray.withOpacity(.4)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "From: ${insight.period.from}",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: AppColors.typoBody,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "To: ${insight.period.to}",
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: AppColors.typoBody,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 28.h),

            /// ===============================
            /// DATA (nếu có)
            /// ===============================
            if (insight.data.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Details",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.bgWhite,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.bgGray.withOpacity(.35),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: insight.data.map((e) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Text(
                            "- $e",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: AppColors.typoBody,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
