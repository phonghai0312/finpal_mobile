import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'insight_detail_notifier.dart';

final insightDetailNotifierProvider =
    StateNotifierProvider<InsightDetailNotifier, InsightDetailState>((ref) {
      return InsightDetailNotifier(ref);
    });
