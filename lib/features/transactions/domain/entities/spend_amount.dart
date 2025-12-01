import 'package:equatable/equatable.dart';

class SpendAmount extends Equatable {
  final String categoryId;
  final String? categoryName;
  final double spentAmount;

  const SpendAmount({
    required this.categoryId,
    required this.spentAmount,
    this.categoryName,
  });

  @override
  List<Object?> get props => [categoryId, categoryName, spentAmount];
}


