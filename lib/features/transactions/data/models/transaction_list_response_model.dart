import 'transaction_model.dart';

class TransactionListResponseModel {
  final List<TransactionModel> items;
  final int page;
  final int pageSize;
  final int total;

  TransactionListResponseModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  factory TransactionListResponseModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return TransactionListResponseModel(
      items: rawItems
          .map((item) =>
              TransactionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? rawItems.length,
      total: (json['total'] as num?)?.toInt() ?? rawItems.length,
    );
  }
}



