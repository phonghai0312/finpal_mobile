// ignore_for_file: use_super_parameters

import 'package:fridge_to_fork_ai/features/home/data/models/stats_period_model.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/suggestions.dart';

class SuggestionModel extends Suggestions {
  SuggestionModel({
    required String id,
    required String userId,
    required String type,
    required StatsPeriodModel period,
    required String title,
    required String message,
    required Map<String, dynamic> data,
    required bool read,
    required int createdAt,
    required int updatedAt,
  }) : super(
         id: id,
         userId: userId,
         type: type,
         period: period,
         title: title,
         message: message,
         data: data,
         read: read,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: json['type'] ?? '',
      period: StatsPeriodModel.fromJson(json['period'] ?? {}),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] ?? {}) as Map<String, dynamic>,
      read: json['read'] ?? false,
      createdAt: json['createdAt'] ?? 0,
      updatedAt: json['updatedAt'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'type': type,
    'period': (period as StatsPeriodModel).toJson(),
    'title': title,
    'message': message,
    'data': data,
    'read': read,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
