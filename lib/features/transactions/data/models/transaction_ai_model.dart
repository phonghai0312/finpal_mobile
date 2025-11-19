import '../../domain/entities/transaction_ai.dart';

class TransactionAIModel extends TransactionAI {
  const TransactionAIModel({super.categorySuggestionId, super.confidence});

  factory TransactionAIModel.fromJson(Map<String, dynamic> json) {
    return TransactionAIModel(
      categorySuggestionId: json['categorySuggestionId'],
      confidence: (json['confidence'] as num?)?.toDouble(),
    );
  }

  TransactionAI toEntity() {
    return TransactionAI(
      categorySuggestionId: categorySuggestionId,
      confidence: confidence,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categorySuggestionId': categorySuggestionId,
      'confidence': confidence,
    };
  }
}
