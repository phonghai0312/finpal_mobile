import 'package:equatable/equatable.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/period.dart';

class Insight extends Equatable {
  final String id;
  final String userId;
  final String type;
  final Period period;
  final String title;
  final String message;
  final Map<String, dynamic> data;
  final bool read;
  final int createdAt;
  final int updatedAt;

  const Insight({
    required this.id,
    required this.userId,
    required this.type,
    required this.period,
    required this.title,
    required this.message,
    required this.data,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        period,
        title,
        message,
        data,
        read,
        createdAt,
        updatedAt,
      ];

  Insight copyWith({
    String? id,
    String? userId,
    String? type,
    Period? period,
    String? title,
    String? message,
    Map<String, dynamic>? data,
    bool? read,
    int? createdAt,
    int? updatedAt,
  }) {
    return Insight(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      period: Period.fromJson(json['period'] as Map<String, dynamic>),
      title: json['title'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>,
      read: json['read'] as bool,
      createdAt: json['createdAt'] as int,
      updatedAt: json['updatedAt'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
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
