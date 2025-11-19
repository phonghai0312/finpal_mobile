import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction_ai.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction_nomalized.dart';

class Transaction {
  final String id;
  final String userId;
  final String accountId;
  final double amount;
  final String currency;
  final String direction; // enum: [out, in, transfer]
  final String type; // enum: [expense, income, transfer]
  final String? categoryId;
  final String? categoryName;
  final String? merchant;
  final int occurredAt; // Unix timestamp
  final String rawMessage;
  final TransactionNormalized normalized;
  final TransactionAI ai;
  final String? userNote;
  final String source; // enum: [sepay, manual, import]
  final int createdAt; // Unix timestamp
  final int updatedAt; // Unix timestamp

  const Transaction({
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
    required this.rawMessage,
    required this.normalized,
    required this.ai,
    this.userNote,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });

  Transaction copyWith({
    String? merchant,
    String? userNote,
  }) {
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
      merchant: merchant ?? this.merchant,
      occurredAt: occurredAt,
      rawMessage: rawMessage,
      normalized: normalized,
      ai: ai,
      userNote: userNote ?? this.userNote,
      source: source,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
