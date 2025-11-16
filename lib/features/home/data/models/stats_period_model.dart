// ignore_for_file: use_super_parameters

import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_period.dart';

class StatsPeriodModel extends StatsPeriod {
  StatsPeriodModel({required int from, required int to})
    : super(from: from, to: to);

  factory StatsPeriodModel.fromJson(Map<String, dynamic> json) {
    return StatsPeriodModel(from: json['from'] ?? 0, to: json['to'] ?? 0);
  }

  Map<String, dynamic> toJson() => {'from': from, 'to': to};
}
