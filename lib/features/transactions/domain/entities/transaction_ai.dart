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
