import 'period.dart';

class Insight {
  final String id;
  final String user;
  final String type;
  final Period period;
  final String title;
  final String message;
  final List<String> data;
  final bool read;
  final int createdAt;
  final int updatedAt;

  const Insight({
    required this.id,
    required this.user,
    required this.type,
    required this.period,
    required this.title,
    required this.message,
    required this.data,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
  });

  Insight copyWith({
    String? id,
    String? user,
    String? type,
    Period? period,
    String? title,
    String? message,
    List<String>? data,
    bool? read,
    int? createdAt,
    int? updatedAt,
  }) {
    return Insight(
      id: id ?? this.id,
      user: user ?? this.user,
      type: type ?? this.type,
      period: period ?? this.period,
      title: title ?? this.title,
      message: message ?? this.message,
      data: data ?? this.data,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
