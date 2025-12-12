import '../../domain/entities/insight.dart';
import '../../domain/entities/period.dart';

class InsightModel extends Insight {
  InsightModel({
    required super.id,
    required super.user,
    required super.type,
    required super.period,
    required super.title,
    required super.message,
    required super.data,
    required super.read,
    required super.createdAt,
    required super.updatedAt,
  });

  factory InsightModel.fromJson(Map<String, dynamic> json) {
    // parse data linh hoạt: null / List / Map đều không crash
    List<String> parseData(dynamic raw) {
      if (raw == null) return const [];

      if (raw is List) {
        return raw.map((e) => e.toString()).toList();
      }

      if (raw is Map) {
        // tạm thời convert Map thành list string "key: value"
        return raw.entries.map((e) => '${e.key}: ${e.value}').toList();
      }

      return [raw.toString()];
    }

    return InsightModel(
      id: json['id']?.toString() ?? '',
      user: json['userId']?.toString() ?? '', // ✅ userId
      type: json['type']?.toString() ?? '',
      period: Period.fromJson((json['period'] as Map<String, dynamic>? ?? {})),
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: parseData(json['data']),
      read: (json['read'] as bool?) ?? false,
      createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': user,
      'type': type,
      'period': period.toJson(),
      'title': title,
      'message': message,
      'data': data,
      'read': read,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
