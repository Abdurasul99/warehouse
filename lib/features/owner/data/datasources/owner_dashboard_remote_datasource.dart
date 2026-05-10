import '../../../../core/network/api_client.dart';
import '../../domain/entities/owner_dashboard.dart';

class OwnerDashboardRemoteDataSource {
  final ApiClient _api;
  OwnerDashboardRemoteDataSource(this._api);

  Future<OwnerDashboard> fetch() async {
    final res = await _api.get('/api/dashboard/owner');
    if (res is! Map) {
      throw ApiException(500, 'Unexpected dashboard response shape');
    }
    final json = Map<String, dynamic>.from(res);
    final t = Map<String, dynamic>.from(json['today'] as Map? ?? const {});
    final today = OwnerToday(
      revenue: _num(t['revenue']),
      checkCount: (t['checkCount'] as num?)?.toInt() ?? 0,
      marginPercent: _num(t['marginPercent']),
      deltaPercent: _num(t['deltaPercent']),
      cogs: _num(t['cogs']),
      grossProfit: _num(t['grossProfit']),
    );
    final branches = ((json['branches'] as List?) ?? const [])
        .whereType<Map>()
        .map((m) {
          final b = Map<String, dynamic>.from(m);
          return OwnerBranchSummary(
            id: b['id'] as String,
            name: b['name'] as String,
            address: b['address'] as String?,
            todayRevenue: _num(b['todayRevenue']),
            checkCount: (b['checkCount'] as num?)?.toInt() ?? 0,
            employeeCount: (b['employeeCount'] as num?)?.toInt() ?? 0,
            deltaPercent: _num(b['deltaPercent']),
          );
        })
        .toList();
    final notifications = ((json['notifications'] as List?) ?? const [])
        .whereType<Map>()
        .map((m) {
          final n = Map<String, dynamic>.from(m);
          return OwnerNotification(
            branchId: n['branchId'] as String,
            branchName: n['branchName'] as String,
            deltaPercent: _num(n['deltaPercent']),
            message: n['message'] as String,
          );
        })
        .toList();
    return OwnerDashboard(
      today: today,
      branches: branches,
      notifications: notifications,
    );
  }

  static double _num(dynamic v) =>
      v is num ? v.toDouble() : double.tryParse('$v') ?? 0;
}
