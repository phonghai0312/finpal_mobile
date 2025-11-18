class TransactionCreationRequestModel {
  final double amount;
  final String type;
  final String? categoryId;
  final String? description;
  final String? userNote;
  final int occurredAt;

  TransactionCreationRequestModel({
    required this.amount,
    required this.type,
    this.categoryId,
    this.description,
    this.userNote,
    required this.occurredAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type,
      'categoryId': categoryId,
      'description': description,
      'userNote': userNote,
      'occurredAt': occurredAt,
    };
  }
}
