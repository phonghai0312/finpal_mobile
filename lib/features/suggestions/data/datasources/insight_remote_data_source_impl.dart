import 'package:fridge_to_fork_ai/features/suggestions/data/datasources/insight_remote_data_source.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/insight.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/period.dart';

class InsightRemoteDataSourceImpl implements InsightRemoteDataSource {
  List<Insight> _mockInsights = [
    Insight(
      id: '1',
      userId: 'u001',
      type: 'alert',
      period: Period(from: 1678886400, to: 1681478400), // March
      title: 'Cảnh báo quan trọng!',
      message: 'Chi tiêu cho cà phê tăng 35% so với tháng trước. Bạn đã chi 300.000đ trong tháng này',
      data: {},
      read: false,
      createdAt: 1681478400,
      updatedAt: 1681478400,
    ),
    Insight(
      id: '2',
      userId: 'u001',
      type: 'tip',
      period: Period(from: 1678886400, to: 1681478400), // March
      title: 'Phân tích tự động',
      message: 'AI đã quét & phân loại 125 giao dịch từ SMS ngân hàng tháng này',
      data: {},
      read: false,
      createdAt: 1681478400,
      updatedAt: 1681478400,
    ),
    Insight(
      id: '3',
      userId: 'u001',
      type: 'monthly_summary',
      period: Period(from: 1677600000, to: 1680278399), // February
      title: 'Tiết kiệm tốt hơn tháng trước',
      message: 'Bạn đã tiết kiệm được 12.500.000đ trong tháng này, tăng 8.5% so với tháng trước',
      data: {},
      read: false,
      createdAt: 1680278399,
      updatedAt: 1680278399,
    ),
    Insight(
      id: '4',
      userId: 'u001',
      type: 'budget_alert',
      period: Period(from: 1681478400, to: 1684070400), // April
      title: 'Đề xuất ngân sách',
      message: 'Dựa trên thói quen chi tiêu, bạn nên đặt ngân sách 1.500.000đ cho ăn uống tháng sau',
      data: {},
      read: false,
      createdAt: 1684070400,
      updatedAt: 1684070400,
    ),
    Insight(
      id: '5',
      userId: 'u001',
      type: 'tip',
      period: Period(from: 1684070400, to: 1686662400), // May
      title: 'Mẹo tiết kiệm',
      message: 'Thay vì mua cà phê mỗi ngày, bạn có thể tiết kiệm 200.000đ/tháng nếu tự pha tại nhà 3...',
      data: {},
      read: false,
      createdAt: 1686662400,
      updatedAt: 1686662400,
    ),
  ];

  @override
  Future<List<Insight>> getInsights({String? type, int? page, int? pageSize}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    List<Insight> filteredInsights = _mockInsights;

    if (type != null) {
      filteredInsights = filteredInsights.where((insight) => insight.type == type).toList();
    }

    // Simple pagination for mock data
    final int startIndex = ((page ?? 1) - 1) * (pageSize ?? filteredInsights.length);
    final int endIndex = (startIndex + (pageSize ?? filteredInsights.length)).clamp(0, filteredInsights.length);
    
    return filteredInsights.sublist(startIndex, endIndex);
  }

  @override
  Future<Insight> updateInsight(String id, bool read) async {
    await Future.delayed(const Duration(milliseconds: 500));
    int index = _mockInsights.indexWhere((insight) => insight.id == id);
    if (index != -1) {
      _mockInsights[index] = _mockInsights[index].copyWith(read: read, updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000);
      return _mockInsights[index];
    }
    throw Exception('Insight not found');
  }
}
