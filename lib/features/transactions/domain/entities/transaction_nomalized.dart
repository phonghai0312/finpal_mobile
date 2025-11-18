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
