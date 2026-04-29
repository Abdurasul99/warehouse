import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/mock_data/mock_database.dart';
import '../../../../core/utils/enums.dart';

class DashboardStats {
  final int totalProducts;
  final int lowStockCount;
  final int outOfStockCount;
  final int todayMovements;
  final int totalCategories;

  const DashboardStats({
    required this.totalProducts,
    required this.lowStockCount,
    required this.outOfStockCount,
    required this.todayMovements,
    required this.totalCategories,
  });
}

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  await Future.delayed(const Duration(milliseconds: 200));
  final db = MockDatabase();
  final products = db.products;
  final today = DateTime.now();

  return DashboardStats(
    totalProducts: products.length,
    lowStockCount: products
        .where((p) => p.stockStatus == StockStatus.low)
        .length,
    outOfStockCount: products
        .where((p) => p.stockStatus == StockStatus.critical)
        .length,
    todayMovements: db.movements
        .where((m) =>
            m.createdAt.year == today.year &&
            m.createdAt.month == today.month &&
            m.createdAt.day == today.day)
        .length,
    totalCategories: db.categories.length,
  );
});
