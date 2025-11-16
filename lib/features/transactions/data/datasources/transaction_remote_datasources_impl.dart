import 'package:fridge_to_fork_ai/features/transactions/data/models/transaction_model.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/models/transaction_update_request_model.dart';

import 'transaction_remote_datasources.dart';

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  // Mock data for transactions
  final List<TransactionModel> _mockTransactions = [
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
      occurredAt: 1678886400, // March 15, 2023 12:00:00 PM GMT+07:00
      rawMessage: 'TCH 45000VND',
      normalized: TransactionNormalizedModel(title: 'The Coffee House', description: 'Ăn uống', peerName: 'The Coffee House'),
      ai: TransactionAIModel(categorySuggestionId: 'c001', confidence: 0.9),
      userNote: null,
      source: 'sepay',
      createdAt: 1678886400,
      updatedAt: 1678886400,
    ),
    const TransactionModel(
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
      occurredAt: 1678872900, // March 15, 2023 08:15:00 AM GMT+07:00
      rawMessage: 'Shopee Order #123 250000VND',
      normalized: TransactionNormalizedModel(title: 'Shopee - Đơn hàng #123', description: 'Mua sắm', peerName: 'Shopee'),
      ai: TransactionAIModel(categorySuggestionId: 'c002', confidence: 0.85),
      userNote: null,
      source: 'sepay',
      createdAt: 1678872900,
      updatedAt: 1678872900,
    ),
    const TransactionModel(
      id: 't003',
      userId: 'u001',
      accountId: 'a001',
      amount: 15000000,
      currency: 'VND',
      direction: 'in',
      type: 'income',
      categoryId: 'c003',
      categoryName: 'Thu nhập',
      merchant: 'Lương tháng 11',
      occurredAt: 1678872900, // March 15, 2023 08:15:00 AM GMT+07:00
      rawMessage: 'Lương tháng 11 15000000VND',
      normalized: TransactionNormalizedModel(title: 'Lương tháng 11', description: 'Thu nhập', peerName: 'Công ty ABC'),
      ai: TransactionAIModel(categorySuggestionId: 'c003', confidence: 0.95),
      userNote: null,
      source: 'manual',
      createdAt: 1678872900,
      updatedAt: 1678872900,
    ),
    const TransactionModel(
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
      occurredAt: 1678713600, // March 13, 2023 12:00:00 PM GMT+07:00
      rawMessage: 'Highlands Coffee 65000VND',
      normalized: TransactionNormalizedModel(title: 'Highlands Coffee', description: 'Ăn uống', peerName: 'Highlands Coffee'),
      ai: TransactionAIModel(categorySuggestionId: 'c001', confidence: 0.88),
      userNote: null,
      source: 'sepay',
      createdAt: 1678713600,
      updatedAt: 1678713600,
    ),
    const TransactionModel(
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
      occurredAt: 1678680300, // March 12, 2023 11:45:00 PM GMT+07:00
      rawMessage: 'Grab from home to work 250000VND',
      normalized: TransactionNormalizedModel(title: 'Grab - Từ nhà đến công ty', description: 'Di chuyển', peerName: 'Grab'),
      ai: TransactionAIModel(categorySuggestionId: 'c004', confidence: 0.92),
      userNote: null,
      source: 'sepay',
      createdAt: 1678680300,
      updatedAt: 1678680300,
    ),
    const TransactionModel(
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
      occurredAt: 1678617600, // March 12, 2023 06:00:00 AM GMT+07:00
      rawMessage: 'Phòng khám ABC 5000000VND',
      normalized: TransactionNormalizedModel(title: 'Phòng khám ABC', description: 'Sức khỏe', peerName: 'Phòng khám ABC'),
      ai: TransactionAIModel(categorySuggestionId: 'c005', confidence: 0.8),
      userNote: null,
      source: 'manual',
      createdAt: 1678617600,
      updatedAt: 1678617600,
    ),
  ];

  @override
  Future<TransactionListResponseModel> getTransactions({
    int? from,
    int? to,
    String? type,
    String? direction,
    String? categoryId,
    String? accountId,
    int page = 1,
    int pageSize = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    Iterable<TransactionModel> filteredTransactions = _mockTransactions.where((transaction) {
      if (from != null && transaction.occurredAt < from) return false;
      if (to != null && transaction.occurredAt > to) return false;
      if (type != null && transaction.type != type) return false;
      if (direction != null && transaction.direction != direction) return false;
      if (categoryId != null && transaction.categoryId != categoryId) return false;
      if (accountId != null && transaction.accountId != accountId) return false;
      return true;
    });

    final total = filteredTransactions.length;
    final startIndex = (page - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, total);
    final items = filteredTransactions.toList().sublist(startIndex, endIndex);

    return TransactionListResponseModel(
      items: items,
      page: page,
      pageSize: pageSize,
      total: total,
    );
  }

  @override
  Future<TransactionModel> getTransactionDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockTransactions.firstWhere(
      (transaction) => transaction.id == id,
      orElse: () => throw Exception('Transaction not found'),
    );
  }

  @override  Future<TransactionModel> updateTransaction(
    String id,
    TransactionUpdateRequestModel request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _mockTransactions.indexWhere((transaction) => transaction.id == id);
    if (index == -1) {
      throw Exception('Transaction not found');
    }

    final existingTransaction = _mockTransactions[index];
    final updatedTransaction = TransactionModel(
      id: existingTransaction.id,
      userId: existingTransaction.userId,
      accountId: existingTransaction.accountId,
      amount: existingTransaction.amount,
      currency: existingTransaction.currency,
      direction: existingTransaction.direction,
      type: existingTransaction.type,
      categoryId: request.categoryId ?? existingTransaction.categoryId,
      categoryName: existingTransaction.categoryName, // categoryName is derived, not updated directly
      merchant: existingTransaction.merchant,
      occurredAt: existingTransaction.occurredAt,
      rawMessage: existingTransaction.rawMessage,
      normalized: existingTransaction.normalized,
      ai: existingTransaction.ai,
      userNote: request.userNote ?? existingTransaction.userNote,
      source: existingTransaction.source,
      createdAt: existingTransaction.createdAt,
      updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );

    _mockTransactions[index] = updatedTransaction;
    return updatedTransaction;
  }
}
