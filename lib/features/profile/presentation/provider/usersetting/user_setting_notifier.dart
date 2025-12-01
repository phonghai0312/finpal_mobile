import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:go_router/go_router.dart';

class UserSettingsState {
  final String language;
  final String currency;
  final String timezone;

  final bool pushNewTransaction;
  final bool pushFinanceSuggestion;
  final bool pushMonthlyReport;

  const UserSettingsState({
    this.language = "Tiếng Việt",
    this.currency = "VND (đ)",
    this.timezone = "GMT +7 (Hồ Chí Minh)",
    this.pushNewTransaction = true,
    this.pushFinanceSuggestion = true,
    this.pushMonthlyReport = true,
  });

  UserSettingsState copyWith({
    String? language,
    String? currency,
    String? timezone,
    bool? pushNewTransaction,
    bool? pushFinanceSuggestion,
    bool? pushMonthlyReport,
  }) {
    return UserSettingsState(
      language: language ?? this.language,
      currency: currency ?? this.currency,
      timezone: timezone ?? this.timezone,
      pushNewTransaction: pushNewTransaction ?? this.pushNewTransaction,
      pushFinanceSuggestion:
          pushFinanceSuggestion ?? this.pushFinanceSuggestion,
      pushMonthlyReport: pushMonthlyReport ?? this.pushMonthlyReport,
    );
  }
}

class UserSettingsNotifier extends StateNotifier<UserSettingsState> {
  UserSettingsNotifier() : super(const UserSettingsState());

  void openLanguage() {
    // TODO: Navigate to language page
  }

  void openCurrency() {
    // TODO: Navigate to currency page
  }

  void openTimezone() {
    // TODO: Navigate to timezone page
  }

  void togglePushNewTransaction(bool value) {
    state = state.copyWith(pushNewTransaction: value);
  }

  void togglePushFinanceSuggestion(bool value) {
    state = state.copyWith(pushFinanceSuggestion: value);
  }

  void togglePushMonthlyReport(bool value) {
    state = state.copyWith(pushMonthlyReport: value);
  }

  void onBack(BuildContext context) {
    context.go(AppRoutes.profile);
  }
}
