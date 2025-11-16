import '../../../stats/domain/entities/stats_period.dart';

class Suggestions {
  final String id;
  final String userId;
  final String type; // weekly_summary, monthly_summary, alert, tip
  final StatsPeriod period;
  final String title;
  final String message;
  final Map<String, dynamic> data;
  final bool read;
  final int createdAt;
  final int updatedAt;

  const Suggestions({
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
}
