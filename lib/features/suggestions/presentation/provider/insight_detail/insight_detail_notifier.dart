// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/presentation/theme/app_colors.dart';

import '../../../domain/entities/insight.dart';
import '../insight/insight_provider.dart';

/// ============================
/// STATE
/// ============================
class InsightDetailState {
  final Insight? insight;

  const InsightDetailState({this.insight});

  InsightDetailState copyWith({Insight? insight}) {
    return InsightDetailState(insight: insight ?? this.insight);
  }
}

/// ============================
/// NOTIFIER
/// ============================
class InsightDetailNotifier extends StateNotifier<InsightDetailState> {
  final Ref ref;

  InsightDetailNotifier(this.ref) : super(const InsightDetailState());

  /// INIT — giống BookingDetailNotifier
  void init(BuildContext context) {
    final selectedInsight = ref.read(insightsNotifierProvider).selectedInsight;

    if (selectedInsight != null) {
      state = state.copyWith(insight: selectedInsight);
    }
  }

  /// Back
  void onBack(BuildContext context) {
    context.go(AppRoutes.suggestions);
  }

  /// Style theo type
  Map<String, dynamic> getDesign(String type) {
    switch (type) {
      case "alert":
        return {
          'icon': Icons.warning_amber_outlined,
          'color': Colors.amber.shade400,
        };

      case "tip":
        return {
          'icon': Icons.lightbulb_outline,
          'color': Colors.lightGreen.shade400,
        };

      case "summary":
        return {
          'icon': Icons.analytics_outlined,
          'color': Colors.lightBlue.shade400,
        };

      case "anomaly":
        return {
          'icon': Icons.error_outline,
          'color': Colors.red.shade400,
        };

      case "budget_alert":
        return {
          'icon': Icons.account_balance_wallet_outlined,
          'color': Colors.orange.shade400,
        };

      case "monthly_summary":
        return {
          'icon': Icons.stacked_line_chart,
          'color': Colors.lightBlue.shade400,
        };

      case "daily_report":
        return {
          'icon': Icons.show_chart,
          'color': Colors.lightBlue.shade400,
        };

      case "monthly_report":
        return {
          'icon': Icons.monitor_heart_outlined,
          'color': Colors.lightBlue.shade400,
        };

      default:
        return {'icon': Icons.info_outline, 'color': AppColors.typoBody};
    }
  }
}
