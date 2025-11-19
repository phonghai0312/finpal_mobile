import 'dart:async';

import 'package:fridge_to_fork_ai/features/transactions/data/models/transaction_ai_model.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/models/transaction_normalized_model.dart';

import '../models/transaction_model.dart';

/// Fake datasource for Transactions
class TransactionRemoteDataSource {
  final List<TransactionModel> _mock = [
    const TransactionModel(
      id: 't001',
      userId: 'u001',
      accountId: 'a001',
      amount: 45000,
      currency: 'VND',
      direction: 'out',
      type: 'expense',
      categoryId: 'c001',
      categoryName: 'Ăn uống',
      merchant: 'The Coffee House',
      occurredAt: 1708157400, // hôm nay 14:30
      rawMessage: 'TCH 45000VND',
      normalized: TransactionNormalizedModel(
        title: 'The Coffee House',
        description: 'Ăn uống',
        peerName: 'The Coffee House',
      ),
      ai: TransactionAIModel(categorySuggestionId: 'c001', confidence: 0.91),
      source: 'sepay',
      userNote: null,
      createdAt: 1708157400,
      updatedAt: 1708157400,
    ),

    // Shopee
    TransactionModel(
      id: 't002',
      userId: 'u001',
      accountId: 'a001',
      amount: 250000,
      currency: 'VND',
      direction: 'out',
      type: 'expense',
      categoryId: 'c002',
      categoryName: 'Mua sắm',
      merchant: 'Shopee',
      occurredAt: 1708154100, // hôm nay 10:15
      rawMessage: 'Shopee Order #123',
      normalized: const TransactionNormalizedModel(
        title: 'Shopee - Đơn hàng #123',
        description: 'Mua sắm',
        peerName: 'Shopee',
      ),
      ai: const TransactionAIModel(
        categorySuggestionId: 'c002',
        confidence: 0.83,
      ),
      source: 'sepay',
      userNote: null,
      createdAt: 1708154100,
      updatedAt: 1708154100,
    ),

    // Thu nhập
    TransactionModel(
      id: 't003',
      userId: 'u001',
      accountId: 'a001',
      amount: 15000000,
      currency: 'VND',
      direction: 'in',
      type: 'income',
      categoryId: 'c003',
      categoryName: 'Thu nhập',
      merchant: 'Công ty ABC',
      occurredAt: 1708154100, // hôm nay
      rawMessage: 'Lương tháng 11',
      normalized: const TransactionNormalizedModel(
        title: 'Lương tháng 11',
        description: 'Thu nhập',
        peerName: 'Công ty ABC',
      ),
      ai: const TransactionAIModel(
        categorySuggestionId: 'c003',
        confidence: 0.95,
      ),
      source: 'manual',
      userNote: null,
      createdAt: 1708154100,
      updatedAt: 1708154100,
    ),

    // Highlands Coffee
    TransactionModel(
      id: 't004',
      userId: 'u001',
      accountId: 'a001',
      amount: 65000,
      currency: 'VND',
      direction: 'out',
      type: 'expense',
      categoryId: 'c001',
      categoryName: 'Ăn uống',
      merchant: 'Highlands Coffee',
      occurredAt: 1707991200, // 2 ngày trước
      rawMessage: 'Highlands Coffee 65000₫',
      normalized: const TransactionNormalizedModel(
        title: 'Highlands Coffee',
        description: 'Ăn uống',
        peerName: 'Highlands Coffee',
      ),
      ai: const TransactionAIModel(
        categorySuggestionId: 'c001',
        confidence: 0.88,
      ),
      source: 'sepay',
      userNote: null,
      createdAt: 1707991200,
      updatedAt: 1707991200,
    ),

    // Grab
    TransactionModel(
      id: 't005',
      userId: 'u001',
      accountId: 'a001',
      amount: 250000,
      currency: 'VND',
      direction: 'out',
      type: 'expense',
      categoryId: 'c004',
      categoryName: 'Di chuyển',
      merchant: 'Grab',
      occurredAt: 1708077600, // hôm qua 18:45
      rawMessage: 'Grab from home to work',
      normalized: const TransactionNormalizedModel(
        title: 'Grab - Từ nhà đến công ty',
        description: 'Di chuyển',
        peerName: 'Grab',
      ),
      ai: const TransactionAIModel(
        categorySuggestionId: 'c004',
        confidence: 0.92,
      ),
      source: 'sepay',
      userNote: null,
      createdAt: 1708077600,
      updatedAt: 1708077600,
    ),

    // Phòng khám ABC
    TransactionModel(
      id: 't006',
      userId: 'u001',
      accountId: 'a001',
      amount: 5000000,
      currency: 'VND',
      direction: 'out',
      type: 'expense',
      categoryId: 'c005',
      categoryName: 'Sức khỏe',
      merchant: 'Phòng khám ABC',
      occurredAt: 1707904800, // 3 ngày trước
      rawMessage: 'Phòng khám ABC 5.000.000đ',
      normalized: const TransactionNormalizedModel(
        title: 'Phòng khám ABC',
        description: 'Sức khỏe',
        peerName: 'Phòng khám ABC',
      ),
      ai: const TransactionAIModel(
        categorySuggestionId: 'c005',
        confidence: 0.80,
      ),
      source: 'manual',
      userNote: null,
      createdAt: 1707904800,
      updatedAt: 1707904800,
    ),

    // thêm các transaction khác nếu muốn UI dài hơn ↓↓↓
    TransactionModel(
      id: 't007',
      userId: 'u001',
      accountId: 'a001',
      amount: 120000,
      currency: 'VND',
      direction: 'out',
      type: 'expense',
      categoryId: 'c006',
      categoryName: 'Giải trí',
      merchant: 'CGV Vincom',
      occurredAt: 1707818400,
      rawMessage: 'CGV Movie',
      normalized: const TransactionNormalizedModel(
        title: 'CGV - Vé xem phim',
        description: 'Giải trí',
        peerName: 'CGV',
      ),
      ai: const TransactionAIModel(
        categorySuggestionId: 'c006',
        confidence: 0.87,
      ),
      source: 'sepay',
      userNote: null,
      createdAt: 1707818400,
      updatedAt: 1707818400,
    ),

    TransactionModel(
      id: 't008',
      userId: 'u001',
      accountId: 'a001',
      amount: 300000,
      currency: 'VND',
      direction: 'out',
      type: 'expense',
      categoryId: 'c007',
      categoryName: 'Giáo dục',
      merchant: 'Udemy',
      occurredAt: 1707732000,
      rawMessage: 'Udemy Payment',
      normalized: const TransactionNormalizedModel(
        title: 'Udemy - Khoá học Flutter',
        description: 'Giáo dục',
        peerName: 'Udemy',
      ),
      ai: const TransactionAIModel(
        categorySuggestionId: 'c007',
        confidence: 0.79,
      ),
      source: 'manual',
      userNote: null,
      createdAt: 1707732000,
      updatedAt: 1707732000,
    ),

    TransactionModel(
      id: 't009',
      userId: 'u001',
      accountId: 'a001',
      amount: 98000,
      currency: 'VND',
      direction: 'out',
      type: 'expense',
      categoryId: 'c001',
      categoryName: 'Ăn uống',
      merchant: 'Pizza Home',
      occurredAt: 1707645600,
      rawMessage: 'Pizza Home order',
      normalized: const TransactionNormalizedModel(
        title: 'Pizza Home',
        description: 'Ăn uống',
        peerName: 'Pizza Home',
      ),
      ai: const TransactionAIModel(
        categorySuggestionId: 'c001',
        confidence: 0.86,
      ),
      source: 'sepay',
      userNote: null,
      createdAt: 1707645600,
      updatedAt: 1707645600,
    ),
  ];

  /// ============================
  /// GET ALL TRANSACTIONS
  /// ============================
  Future<List<TransactionModel>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mock;
  }

  /// ============================
  /// GET DETAIL
  /// ============================
  Future<TransactionModel> getTransactionDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _mock.firstWhere(
          (t) => t.id == id,
      orElse: () => throw Exception('Transaction not found'),
    );
  }

  /// ============================
  /// UPDATE TRANSACTION  ← KHỚP REPO
  /// ============================
  Future<void> updateTransaction(
      String id, {
        String? categoryId,
        String? userNote,
        String? merchant,
      }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _mock.indexWhere((t) => t.id == id);
    if (index == -1) {
      throw Exception('Transaction not found');
    }

    final t = _mock[index];

    final updated = TransactionModel(
      id: t.id,
      userId: t.userId,
      accountId: t.accountId,
      amount: t.amount,
      currency: t.currency,
      direction: t.direction,
      type: t.type,
      categoryId: categoryId ?? t.categoryId,
      categoryName: t.categoryName,
      merchant: merchant ?? t.merchant,
      occurredAt: t.occurredAt,
      rawMessage: t.rawMessage,
      normalized: t.normalized,
      ai: t.ai,
      userNote: userNote ?? t.userNote,
      source: t.source,
      createdAt: t.createdAt,
      updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );

    _mock[index] = updated;
  }

  /// ============================
  /// CREATE TRANSACTION (NEW)
  /// ============================
  Future<void> createTransaction({
    required double amount,
    required String type,
    required String categoryId,
    required String description,
    required int occurredAt,
    String? note,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final newModel = TransactionModel(
      id: "t${_mock.length + 1}",
      userId: 'u001',
      accountId: 'a001',
      amount: amount,
      currency: 'VND',
      direction: type == "income" ? "in" : "out",
      type: type,
      categoryId: categoryId,
      categoryName: description,
      merchant: description,
      occurredAt: occurredAt,
      rawMessage: description,
      normalized: TransactionNormalizedModel(
        title: description,
        description: description,
        peerName: description,
      ),
      ai: TransactionAIModel(categorySuggestionId: categoryId, confidence: 1.0),
      userNote: note,
      source: 'manual',
      createdAt: occurredAt,
      updatedAt: occurredAt,
    );

    _mock.insert(0, newModel); // thêm vào đầu danh sách
  }
}
