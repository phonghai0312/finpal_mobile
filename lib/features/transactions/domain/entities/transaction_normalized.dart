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

  TransactionNormalized copyWith({
    String? title,
    String? description,
    String? peerName,
    double? balanceAfter,
    Map<String, dynamic>? meta,
  }) {
    return TransactionNormalized(
      title: title ?? this.title,
      description: description ?? this.description,
      peerName: peerName ?? this.peerName,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      meta: meta ?? this.meta,
    );
  }
}
