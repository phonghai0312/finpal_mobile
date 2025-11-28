import '../../domain/entities/spend_amount.dart';

class SpendAmountModel extends SpendAmount {
  const SpendAmountModel({
    required super.categoryId,
    required super.spentAmount,
    super.categoryName,
  });

  factory SpendAmountModel.fromJson(Map<String, dynamic> json) {
    return SpendAmountModel(
      categoryId: json['categoryId']?.toString() ?? '',
      categoryName: json['categoryName']?.toString(),
      spentAmount: (json['spentAmount'] as num?)?.toDouble() ?? 0,
    );
  }
}

class SpendAmountResponseModel {
  final List<SpendAmountModel> items;

  const SpendAmountResponseModel({required this.items});

  factory SpendAmountResponseModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? const [])
        .map((item) => SpendAmountModel.fromJson(item as Map<String, dynamic>))
        .toList();
    return SpendAmountResponseModel(items: rawItems);
  }
}


