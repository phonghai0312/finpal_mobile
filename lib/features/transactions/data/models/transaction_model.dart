import 'package:fridge_to_fork_ai/features/transactions/data/models/transaction_ai_model.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/models/transaction_normalized_model.dart';

import '../../domain/entities/transaction.dart';

class TransactionModel {
  final String id;
  final String userId;
  final String accountId;
  final double amount;
  final String currency;
  final String direction;
  final String type;
  final String? categoryId;
  final String? categoryName;
  final String? merchant;
  final int occurredAt;
  final String? rawMessage;
  final TransactionNormalizedModel normalized;
  final TransactionAIModel ai;
  final String? userNote;
  final String source;
  final int createdAt;
  final int updatedAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.amount,
    required this.currency,
    required this.direction,
    required this.type,
    this.categoryId,
    this.categoryName,
    this.merchant,
    required this.occurredAt,
    this.rawMessage,
    required this.normalized,
    required this.ai,
    this.userNote,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: (json['id'] ?? json['_id']).toString(),
      userId: json['user']?.toString() ?? json['userId']?.toString() ?? '',
      accountId: json['accountId']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      currency: json['currency']?.toString() ?? 'VND',
      direction: json['direction']?.toString() ?? 'out',
      type: json['type']?.toString() ?? 'expense',
      categoryId: json['categoryId']?.toString(),
      categoryName: json['categoryName']?.toString(),
      merchant: json['merchant']?.toString(),
      occurredAt: ((json['occurredAt'] as num?)?.toInt() ?? 0) * 1000,
      rawMessage: json['rawMessage']?.toString(),
      normalized: TransactionNormalizedModel.fromJson(
        (json['normalized'] as Map<String, dynamic>? ?? const {}),
      ),
      ai: TransactionAIModel.fromJson(
        (json['ai'] as Map<String, dynamic>? ?? const {}),
      ),
      userNote: json['userNote']?.toString(),
      source: json['source']?.toString() ?? 'manual',
      createdAt: ((json['createdAt'] as num?)?.toInt() ?? 0) * 1000,
      updatedAt: ((json['updatedAt'] as num?)?.toInt() ?? 0) * 1000,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'accountId': accountId,
      'amount': amount,
      'currency': currency,
      'direction': direction,
      'type': type,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'merchant': merchant,
      'occurredAt': occurredAt,
      'rawMessage': rawMessage,
      'normalized': {
        'title': normalized.title,
        'description': normalized.description,
        'peerName': normalized.peerName,
        'balanceAfter': normalized.balanceAfter,
        'meta': normalized.meta,
      },
      'ai': ai.toJson(),
      'userNote': userNote,
      'source': source,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Transaction toEntity() {
    return Transaction(
      id: id,
      userId: userId,
      accountId: accountId,
      amount: amount,
      currency: currency,
      direction: direction,
      type: type,
      categoryId: categoryId,
      categoryName: categoryName,
      merchant: merchant,
      occurredAt: occurredAt,
      rawMessage: rawMessage ?? "",
      normalized: normalized.toEntity(),
      ai: ai.toEntity(),
      userNote: userNote,
      source: source,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
