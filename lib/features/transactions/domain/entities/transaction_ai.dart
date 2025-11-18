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

  TransactionAI copyWith({
    String? categorySuggestionId,
    double? confidence,
    String? model,
    Map<String, dynamic>? rawResponse,
  }) {
    return TransactionAI(
      categorySuggestionId: categorySuggestionId ?? this.categorySuggestionId,
      confidence: confidence ?? this.confidence,
      model: model ?? this.model,
      rawResponse: rawResponse ?? this.rawResponse,
    );
  }
}
