import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.accountId,
    required super.amount,
    required super.currency,
    required super.direction,
    required super.type,
    super.categoryId,
    super.categoryName,
    super.merchant,
    required super.occurredAt,
    required super.rawMessage,
    required super.normalized,
    required super.ai,
    super.userNote,
    required super.source,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      accountId: json['accountId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      direction: json['direction'] as String,
      type: json['type'] as String,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      merchant: json['merchant'] as String?,
      occurredAt: json['occurredAt'] as int,
      rawMessage: json['rawMessage'] as String,
      normalized: TransactionNormalizedModel.fromJson(
          json['normalized'] as Map<String, dynamic>),
      ai: TransactionAIModel.fromJson(json['ai'] as Map<String, dynamic>),
      userNote: json['userNote'] as String?,
      source: json['source'] as String,
      createdAt: json['createdAt'] as int,
      updatedAt: json['updatedAt'] as int,
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
      'normalized': (normalized as TransactionNormalizedModel).toJson(),
      'ai': (ai as TransactionAIModel).toJson(),
      'userNote': userNote,
      'source': source,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class TransactionNormalizedModel extends TransactionNormalized {
  const TransactionNormalizedModel({
    super.title,
    super.description,
    super.peerName,
    super.balanceAfter,
    super.meta,
  });

  factory TransactionNormalizedModel.fromJson(Map<String, dynamic> json) {
    return TransactionNormalizedModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      peerName: json['peerName'] as String?,
      balanceAfter: (json['balanceAfter'] as num?)?.toDouble(),
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'peerName': peerName,
      'balanceAfter': balanceAfter,
      'meta': meta,
    };
  }
}

class TransactionAIModel extends TransactionAI {
  const TransactionAIModel({
    super.categorySuggestionId,
    super.confidence,
    super.model,
    super.rawResponse,
  });

  factory TransactionAIModel.fromJson(Map<String, dynamic> json) {
    return TransactionAIModel(
      categorySuggestionId: json['categorySuggestionId'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      model: json['model'] as String?,
      rawResponse: json['rawResponse'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categorySuggestionId': categorySuggestionId,
      'confidence': confidence,
      'model': model,
      'rawResponse': rawResponse,
    };
  }
}

class TransactionListResponseModel {
  final List<TransactionModel> items;
  final int page;
  final int pageSize;
  final int total;

  const TransactionListResponseModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  factory TransactionListResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionListResponseModel(
      items: (json['items'] as List<dynamic>)
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'page': page,
      'pageSize': pageSize,
      'total': total,
    };
  }
}
