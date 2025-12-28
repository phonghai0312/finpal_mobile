// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/suggestions/presentation/provider/insight_detail/insight_detail_provider.dart';
import 'package:intl/intl.dart';

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
  NumberFormat get _moneyFormat =>
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

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
      backgroundColor: AppColors.bgSecondary,
      appBar: HeaderWithBack(
        title: "Chi tiết gợi ý",
        onBack: () => notifier.onBack(context),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===============================
            ///  TYPE SECTION
            /// ===============================
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(typeIcon, color: typeColor, size: 22.sp),
                  ),
                  SizedBox(width: 12.w),

                  Expanded(
                    child: Text(
                      insight.type.toUpperCase(),
                      style: TextStyle(
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
              style: TextStyle(
                fontSize: 19.sp,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                insight.message,
                style: TextStyle(
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
              "Thời gian",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoHeading,
              ),
            ),

            SizedBox(height: 10.h),

            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "From: ${_formatEpoch(insight.period.from)}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.typoBody,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "To: ${_formatEpoch(insight.period.to)}",
                      textAlign: TextAlign.right,
                      style: TextStyle(
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
                    "Chi tiết",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  Column(
                    children: insight.data
                        .map((e) => _buildDetailItem(e))
                        .toList(),
                  ),
                ],
              ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  String _formatEpoch(int value) {
    final ms = value < 1000000000000 ? value * 1000 : value;
    return DateFormat('dd/MM/yyyy').format(
      DateTime.fromMillisecondsSinceEpoch(ms),
    );
  }

  Map<String, String> _parseDetailMap(String raw) {
    final trimmed = raw.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      return {};
    }
    final body = trimmed.substring(1, trimmed.length - 1);
    final parts = body.split(RegExp(r',\s*'));
    final map = <String, String>{};
    for (final part in parts) {
      final idx = part.indexOf(':');
      if (idx == -1) continue;
      final key = part.substring(0, idx).trim();
      final value = part.substring(idx + 1).trim();
      if (key.isNotEmpty) {
        map[key] = value;
      }
    }
    return map;
  }

  MapEntry<String, String>? _parseKeyValueLine(String raw) {
    final trimmed = raw.trim();
    final idx = trimmed.indexOf(':');
    if (idx == -1) return null;
    final key = trimmed.substring(0, idx).trim();
    final value = trimmed.substring(idx + 1).trim();
    if (key.isEmpty) return null;
    return MapEntry(key, value);
  }

  String _prettyKey(String key) {
    switch (key) {
      case 'totalAmount':
        return 'Tổng tiền';
      case 'spentAmount':
        return 'Đã chi';
      case 'budgetAmount':
      case 'limitAmount':
        return 'Ngân sách';
      case 'count':
        return 'Số giao dịch';
      case 'categoryName':
        return 'Danh mục';
      case 'categoryId':
        return 'Mã danh mục';
      default:
        final withSpace = key.replaceAll('_', ' ');
        return withSpace.isEmpty
            ? key
            : withSpace[0].toUpperCase() + withSpace.substring(1);
    }
  }

  String _formatValue(String key, String value) {
    if (key.endsWith('Amount')) {
      final amount = num.tryParse(value);
      if (amount != null) {
        return _moneyFormat.format(amount);
      }
    }
    if (key == 'count') {
      final count = int.tryParse(value);
      if (count != null) {
        return count.toString();
      }
    }
    return value;
  }

  Widget _buildDetailItem(String raw) {
    final cleanRaw = raw.replaceFirst(RegExp(r'^-\s*'), '').trim();
    final map = _parseDetailMap(cleanRaw);
    final title = map['categoryName'] ?? map['title'] ?? map['name'];
    final detailEntries = Map<String, String>.from(map)
      ..remove('categoryName')
      ..remove('title')
      ..remove('name');

    if (map.isEmpty) {
      final kv = _parseKeyValueLine(cleanRaw);
      if (kv != null) {
        if (kv.key == 'categoryId') {
          return const SizedBox.shrink();
        }
        return _buildKeyValueTile(kv.key, kv.value);
      }
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          cleanRaw,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.typoBody,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title.trim().isNotEmpty)
            Text(
              title,
              style: TextStyle(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoHeading,
              ),
            ),
          if (title != null) SizedBox(height: 10.h),
          ...detailEntries.entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      _prettyKey(entry.key),
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        color: AppColors.typoBody,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 3,
                    child: Text(
                      _formatValue(entry.key, entry.value),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        color: AppColors.typoHeading,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildKeyValueTile(String key, String value) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              _prettyKey(key),
              style: TextStyle(
                fontSize: 13.5.sp,
                color: AppColors.typoBody,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 3,
            child: Text(
              _formatValue(key, value),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13.5.sp,
                color: AppColors.typoHeading,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
