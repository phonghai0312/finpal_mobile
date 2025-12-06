import 'package:fridge_to_fork_ai/features/suggestions/data/models/insight_model.dart';

class InsightResponseModel {
  final List<InsightModel> items;
  final int page;
  final int pageSize;
  final int total;

  InsightResponseModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  factory InsightResponseModel.fromJson(Map<String, dynamic> json) {
    return InsightResponseModel(
      items: (json['items'] as List)
          .map((e) => InsightModel.fromJson(e))
          .toList(),
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
      total: json['total'] ?? 0,
    );
  }
}
