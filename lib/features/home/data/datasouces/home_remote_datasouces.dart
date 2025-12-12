import 'dart:async';

import 'package:fridge_to_fork_ai/features/home/data/models/stats_by_category_item_model.dart';
import 'package:fridge_to_fork_ai/features/home/data/models/stats_by_category_model.dart';
import 'package:fridge_to_fork_ai/features/home/data/models/stats_overview_model.dart';
import 'package:fridge_to_fork_ai/features/home/data/models/stats_period_model.dart';

import 'package:fridge_to_fork_ai/features/home/data/models/user_model.dart'
    show UserModel;

class HomeRemoteDataSource {
  Future<UserModel> getUserInfo() async {
    await Future.delayed(const Duration(milliseconds: 250));

    return UserModel(
      id: "u001",
      email: "nguyenvana@gmail.com",
      phone: "0123456789",
      name: "Nguyễn Văn Hai",
      avatarUrl: null,
      settings: null,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  // ==========================
  // 📌 1) MOCK Stats Overview
  // ==========================
  Future<StatsOverviewModel> getStatsOverview() async {
    await Future.delayed(const Duration(milliseconds: 250));

    return StatsOverviewModel(
      period: StatsPeriodModel(from: 1704067200, to: 1706659200),
      currency: "VND",
      totalExpense: 250000.0,
      totalIncome: 2000000.0,
      totalTransactions: 42,
    );
  }

  // ==========================
  // 📌 2) MOCK Stats By Category
  // ==========================
  Future<StatsByCategoryModel> getStatsByCategory() async {
    await Future.delayed(const Duration(milliseconds: 250));

    return StatsByCategoryModel(
      period: StatsPeriodModel(from: 1704067200, to: 1706659200),
      currency: "VND",
      totalExpense: 250000.0,
      items: [
        StatsByCategoryItemModel(
          categoryId: "eat",
          categoryName: "Ăn uống",
          totalAmount: 150000.0,
          percentage: 60.0,
        ),
        StatsByCategoryItemModel(
          categoryId: "shopping",
          categoryName: "Mua sắm",
          totalAmount: 70000.0,
          percentage: 28.0,
        ),
        StatsByCategoryItemModel(
          categoryId: "move",
          categoryName: "Di chuyển",
          totalAmount: 30000.0,
          percentage: 12.0,
        ),
      ],
    );
  }

  // ==========================
  // 📌 3) MOCK Latest Suggestion
}
