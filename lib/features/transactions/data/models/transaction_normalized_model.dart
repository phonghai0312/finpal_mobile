import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction_nomalized.dart';

class TransactionNormalizedModel {
  final String? title;
  final String? description;
  final String? peerName;
  final double? balanceAfter;
  final Map<String, dynamic>? meta;

  const TransactionNormalizedModel({
    this.title,
    this.description,
    this.peerName,
    this.balanceAfter,
    this.meta,
  });

  factory TransactionNormalizedModel.fromJson(Map<String, dynamic> json) {
    return TransactionNormalizedModel(
      title: json['title'],
      description: json['description'],
      peerName: json['peerName'],
      balanceAfter: (json['balanceAfter'] as num?)?.toDouble(),
      meta: json['meta'],
    );
  }

  TransactionNormalized toEntity() {
    return TransactionNormalized(
      title: title,
      description: description,
      peerName: peerName,
      balanceAfter: balanceAfter,
      meta: meta,
    );
  }
}
