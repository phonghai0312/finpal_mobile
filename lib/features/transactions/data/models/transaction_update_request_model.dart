class TransactionUpdateRequestModel {
  final String? categoryId;
  final String? userNote;

  const TransactionUpdateRequestModel({
    this.categoryId,
    this.userNote,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'userNote': userNote,
    };
  }
}
