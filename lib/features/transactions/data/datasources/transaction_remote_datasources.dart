import 'package:dio/dio.dart';

import 'package:fridge_to_fork_ai/core/network/api_client.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/api/transaction_api.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/models/transaction_model.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/models/spend_amount_model.dart';

class TransactionRemoteDataSource {
  TransactionRemoteDataSource({TransactionApi? api, ApiClient? client})
    : _api = api ?? (client ?? ApiClient()).create(TransactionApi.new);

  final TransactionApi _api;

  Future<List<TransactionModel>> getTransactions() async {
    final response = await _guardRequest(() => _api.getTransactions());
    return response.items;
  }

  Future<TransactionModel> getTransactionDetail(String id) {
    return _guardRequest(() => _api.getTransactionDetail(id));
  }

  Future<void> updateTransaction(
    String id, {
    String? categoryId,
    String? userNote,
    String? merchant,
  }) async {
    final body = <String, dynamic>{};
    if (categoryId != null) body['categoryId'] = categoryId;
    if (userNote != null) body['userNote'] = userNote;
    if (merchant != null) body['merchant'] = merchant;

    await _guardRequest(() => _api.updateTransaction(id, body));
  }

  Future<void> deleteTransaction(String id) async {
     await _guardRequest(() => _api.deleteTransaction(id));
  }

  Future<TransactionModel> createTransaction({
    required double amount,
    required String type,
    required String categoryId,
    required String title,
    required int occurredAt,
    String? note,
  }) async {
    // Calculate direction from type: expense -> 'out', income -> 'in'
    final direction = type == 'expense' ? 'out' : 'in';
    
    final body = <String, dynamic>{
      'amount': amount,
      'type': type,
      'direction': direction,
      'currency': 'VND', // Default currency
      'category': categoryId,
      'userNote': note ?? '',
      'occurredAt': occurredAt,
      'source': 'manual', // Manual transaction creation
      'normalized': {
        'title': title.isNotEmpty ? title : null,
      },
    };

    // Note: user and account are handled by backend from auth token

    final result = await _guardRequest(() => _api.createTransaction(body));
    return result;
  }

  Future<List<SpendAmountModel>> getSpendAmounts({String? categoryId}) async {
    final response = await _guardRequest(
      () => _api.getSpendAmounts(categoryId: categoryId),
    );
    return response.items;
  }

  Future<T> _guardRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (dioError) {
      final dynamic data = dioError.response?.data;
      final message = (data is Map && data['message'] is String)
          ? data['message'] as String
          : dioError.message;
      throw Exception(message ?? 'Unexpected server error');
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
