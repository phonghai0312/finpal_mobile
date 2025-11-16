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
}

class TransactionNormalized {
  final String? title;
  final String? description;
  final String? peerName;
  final double? balanceAfter;
  final Map<String, dynamic>? meta;

  const TransactionNormalized({
    this.title,
    this.description,
    this.peerName,
    this.balanceAfter,
    this.meta,
  });
}

class TransactionAI {
  final String? categorySuggestionId;
  final double? confidence;
  final String? model;
  final Map<String, dynamic>? rawResponse;

  const TransactionAI({
    this.categorySuggestionId,
    this.confidence,
    this.model,
    this.rawResponse,
  });
}
