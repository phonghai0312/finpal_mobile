// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finpal/features/suggestions/presentation/provider/insight_detail/insight_detail_provider.dart';
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
            ///  HERO CARD
            /// ===============================
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    typeColor.withOpacity(0.18),
                    typeColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: typeColor.withOpacity(0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Icon(typeIcon, color: typeColor, size: 22.sp),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              _formatInsightType(insight.type),
                              style: TextStyle(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w700,
                                color: typeColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            _formatDateTime(insight.createdAt),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.typoBody,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (!insight.read)
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: typeColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    insight.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.typoHeading,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    insight.message,
                    style: TextStyle(
                      fontSize: 14.5.sp,
                      height: 1.4,
                      color: AppColors.typoBody,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

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
                color: typeColor.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: typeColor.withOpacity(0.18)),
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
                    child: _buildPeriodItem(
                      icon: Icons.calendar_today_outlined,
                      label: "Từ",
                      value: _formatEpoch(insight.period.from),
                      accentColor: typeColor,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildPeriodItem(
                      icon: Icons.calendar_month_outlined,
                      label: "Đến",
                      value: _formatEpoch(insight.period.to),
                      accentColor: typeColor,
                      alignEnd: true,
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
                        .map((e) => _buildDetailItem(e, typeColor))
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

  String _formatDateTime(int value) {
    final ms = value < 1000000000000 ? value * 1000 : value;
    return DateFormat('dd/MM • HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch(ms),
    );
  }

  Widget _buildPeriodItem({
    required IconData icon,
    required String label,
    required String value,
    required Color accentColor,
    bool alignEnd = false,
  }) {
    return Row(
      mainAxisAlignment:
          alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Icon(icon, size: 16.sp, color: accentColor),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment:
              alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.typoBody,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoHeading,
              ),
            ),
          ],
        ),
      ],
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
        map[key] = value == 'null' ? '' : value;
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

  List<Map<String, String>> _parseListOfMaps(String raw) {
    final trimmed = raw.trim();
    if (!trimmed.startsWith('[') || !trimmed.endsWith(']')) {
      return [];
    }
    final body = trimmed.substring(1, trimmed.length - 1).trim();
    if (body.isEmpty) return [];
    final segments = <String>[];
    final buffer = StringBuffer();
    var depth = 0;
    for (var i = 0; i < body.length; i++) {
      final char = body[i];
      if (char == '{') {
        depth++;
      }
      if (depth > 0) {
        buffer.write(char);
      }
      if (char == '}') {
        depth--;
        if (depth == 0) {
          segments.add(buffer.toString().trim());
          buffer.clear();
        }
      }
    }
    return segments
        .map(_parseDetailMap)
        .where((map) => map.isNotEmpty)
        .toList();
  }

  String _prettyKey(String key) {
    switch (key) {
      case 'totalAmount':
        return 'Tổng tiền';
      case 'spentAmount':
        return 'Đã chi';
      case 'budgetLimit':
        return 'Ngân sách';
      case 'expenseCur':
        return 'Chi tiêu tháng này';
      case 'incomeCur':
        return 'Thu nhập tháng này';
      case 'saving':
        return 'Tiết kiệm tháng này';
      case 'savingRate':
        return 'Tỷ lệ tiết kiệm';
      case 'expensePrev':
        return 'Chi tiêu tháng trước';
      case 'incomePrev':
        return 'Thu nhập tháng trước';
      case 'diffExpense':
        return 'Chênh lệch chi tiêu';
      case 'diffIncome':
        return 'Chênh lệch thu nhập';
      case 'usagePercentage':
        return 'Tỷ lệ sử dụng';
      case 'percentage':
        return 'Tỷ lệ';
      case 'budgetAmount':
      case 'limitAmount':
        return 'Ngân sách';
      case 'totalExpense':
        return 'Tổng chi';
      case 'totalIncome':
        return 'Tổng thu';
      case 'totalTransactions':
        return 'Số giao dịch';
      case 'count':
        return 'Số giao dịch';
      case 'categoryName':
        return 'Danh mục';
      case 'categoryId':
        return 'Mã danh mục';
      case 'type':
        return 'Loại';
      case 'expenses':
        return 'Chi tiêu';
      case 'incomes':
        return 'Thu nhập';
      case 'summary':
        return 'Tổng kết';
      default:
        final withSpace = key.replaceAll('_', ' ');
        return withSpace.isEmpty
            ? key
            : withSpace[0].toUpperCase() + withSpace.substring(1);
    }
  }

  num? _tryParseNumber(String value) {
    final cleaned = value.replaceAll(RegExp(r'[₫\s,]'), '');
    return num.tryParse(cleaned);
  }

  String _formatInsightType(String type) {
    switch (type) {
      case 'daily_report':
        return 'Báo cáo ngày';
      case 'monthly_report':
        return 'Báo cáo tháng';
      case 'monthly_summary':
        return 'Tổng kết tháng';
      case 'budget_alert':
        return 'Cảnh báo ngân sách';
      case 'alert':
        return 'Cảnh báo';
      case 'tip':
        return 'Mẹo';
      default:
        final withSpace = type.replaceAll('_', ' ');
        return withSpace.isEmpty
            ? type
            : withSpace[0].toUpperCase() + withSpace.substring(1);
    }
  }

  String _formatValue(String key, String value) {
    final lowerKey = key.toLowerCase();
    final moneyKeys = <String>{
      'totalamount',
      'spentamount',
      'budgetlimit',
      'budgetamount',
      'limitamount',
      'expensecur',
      'incomecur',
      'saving',
      'expenseprev',
      'incomeprev',
      'diffexpense',
      'diffincome',
      'totalexpense',
      'totalincome',
    };
    final isMoneyKey = moneyKeys.contains(lowerKey) ||
        lowerKey.contains('amount') ||
        lowerKey.contains('limit');
    if (isMoneyKey) {
      final amount = _tryParseNumber(value);
      if (amount != null) {
        if (lowerKey.startsWith('diff')) {
          if (amount == 0) {
            return _moneyFormat.format(0);
          }
          final sign = amount > 0 ? '+' : '-';
          return '$sign${_moneyFormat.format(amount.abs())}';
        }
        return _moneyFormat.format(amount);
      }
    }
    if (lowerKey.contains('percentage') ||
        lowerKey.contains('percent') ||
        lowerKey.contains('rate')) {
      if (value.contains('%')) return value;
      final percentage = _tryParseNumber(value);
      if (percentage != null) {
        final normalized = percentage <= 1 ? percentage * 100 : percentage;
        return '${normalized.toStringAsFixed(normalized % 1 == 0 ? 0 : 2)}%';
      }
      return '$value%';
    }
    if (key == 'count') {
      final count = int.tryParse(value);
      if (count != null) {
        return count.toString();
      }
    }
    if (lowerKey.contains('category') && value.contains('_')) {
      return _titleize(value.replaceAll('_', ' '));
    }
    return value;
  }

  String _titleize(String raw) {
    final cleaned = raw.trim();
    if (cleaned.isEmpty) return raw;
    final parts = cleaned.split(RegExp(r'\s+'));
    return parts
        .map((part) =>
            part.isEmpty ? part : part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  List<MapEntry<String, String>> _sortedDetailEntries(
    Map<String, String> source,
  ) {
    const priority = [
      'totalAmount',
      'spentAmount',
      'totalExpense',
      'totalIncome',
      'saving',
      'count',
      'usagePercentage',
      'percentage',
      'savingRate',
      'diffExpense',
      'diffIncome',
    ];
    final entries = source.entries.toList();
    entries.sort((a, b) {
      final aIndex = priority.indexOf(a.key);
      final bIndex = priority.indexOf(b.key);
      if (aIndex == -1 && bIndex == -1) {
        return a.key.compareTo(b.key);
      }
      if (aIndex == -1) return 1;
      if (bIndex == -1) return -1;
      return aIndex.compareTo(bIndex);
    });
    return entries;
  }

  Widget _buildDetailItem(String raw, Color accentColor) {
    final cleanRaw = raw.replaceFirst(RegExp(r'^-\s*'), '').trim();
    final map = _parseDetailMap(cleanRaw);
    final title = map['categoryName'] ?? map['title'] ?? map['name'];
    final detailEntries = Map<String, String>.from(map)
      ..remove('categoryName')
      ..remove('categoryId')
      ..remove('title')
      ..remove('name');

    if (map.isEmpty) {
      final kv = _parseKeyValueLine(cleanRaw);
      if (kv != null) {
        if (kv.key == 'categoryId') {
          return const SizedBox.shrink();
        }
        final mapValue = _parseDetailMap(kv.value);
        if (mapValue.isNotEmpty) {
          return _buildKeyValueMapTile(kv.key, mapValue, accentColor);
        }
        final listItems = _parseListOfMaps(kv.value);
        if (listItems.isNotEmpty) {
          return _buildKeyValueListTile(kv.key, listItems, accentColor);
        }
        return _buildKeyValueTile(kv.key, kv.value, accentColor);
      }
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: accentColor.withOpacity(0.18)),
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
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: accentColor.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4.w,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  bottomLeft: Radius.circular(14.r),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(14.w),
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
                    ..._sortedDetailEntries(detailEntries).map((entry) {
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyValueMapTile(
    String key,
    Map<String, String> mapValue,
    Color accentColor,
  ) {
    final detailEntries = Map<String, String>.from(mapValue)
      ..removeWhere((_, value) => value.trim().isEmpty);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: accentColor.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4.w,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  bottomLeft: Radius.circular(14.r),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _prettyKey(key),
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        color: AppColors.typoBody,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ..._sortedDetailEntries(detailEntries).map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                _prettyKey(entry.key),
                                style: TextStyle(
                                  fontSize: 13.sp,
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
                                  fontSize: 13.sp,
                                  color: AppColors.typoHeading,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyValueListTile(
    String key,
    List<Map<String, String>> items,
    Color accentColor,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: accentColor.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4.w,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  bottomLeft: Radius.circular(14.r),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _prettyKey(key),
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        color: AppColors.typoBody,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ...items.map((item) {
                      final title =
                          item['categoryName'] ?? item['title'] ?? item['name'];
                      final detailEntries = Map<String, String>.from(item)
                        ..remove('categoryName')
                        ..remove('categoryId')
                        ..remove('title')
                        ..remove('name');
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (title != null && title.trim().isNotEmpty)
                              Text(
                                _titleize(title),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.typoHeading,
                                ),
                              ),
                            if (title != null && title.trim().isNotEmpty)
                              SizedBox(height: 8.h),
                            ..._sortedDetailEntries(detailEntries).map(
                              (entry) => Padding(
                                padding: EdgeInsets.only(bottom: 6.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _prettyKey(entry.key),
                                        style: TextStyle(
                                          fontSize: 12.5.sp,
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
                                          fontSize: 12.5.sp,
                                          color: AppColors.typoHeading,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyValueTile(String key, String value, Color accentColor) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: accentColor.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4.w,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  bottomLeft: Radius.circular(14.r),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(14.w),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
