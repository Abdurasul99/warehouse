import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/enums.dart';
import '../../../../shared/mock_data/mock_database.dart';
import '../../../../shared/models/product_model.dart';
import '../../../products/presentation/providers/product_provider.dart';

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
  final userId = ref.watch(currentUserIdProvider);
  final products = userId == null
      ? <ProductModel>[]
      : db.products.where((p) => p.ownerUserId == userId).toList();
  final productIds = products.map((p) => p.id).toSet();
  final today = DateTime.now();

  return DashboardStats(
    totalProducts: products.length,
    lowStockCount:
        products.where((p) => p.stockStatus == StockStatus.low).length,
    outOfStockCount: products
        .where((p) => p.stockStatus == StockStatus.critical)
        .length,
    todayMovements: db.movements
        .where((m) =>
            productIds.contains(m.productId) &&
            m.createdAt.year == today.year &&
            m.createdAt.month == today.month &&
            m.createdAt.day == today.day)
        .length,
    totalCategories: db.categories.length,
  );
});
