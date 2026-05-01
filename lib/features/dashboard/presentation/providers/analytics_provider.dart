import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/enums.dart';
import '../../../../shared/mock_data/mock_database.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/models/stock_movement_model.dart';
import '../../domain/analytics_summary.dart';

final analyticsSummaryProvider = FutureProvider<AnalyticsSummary>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 80));
  final db = MockDatabase();
  final products = db.products;
  final movements = db.movements;

  final ok = products.where((p) => p.stockStatus == StockStatus.ok).length;
  final low = products.where((p) => p.stockStatus == StockStatus.low).length;
  final critical =
      products.where((p) => p.stockStatus == StockStatus.critical).toList();

  final reorderCandidates = products
      .where((p) => p.minQuantity > 0 && p.currentQuantity <= p.minQuantity)
      .map((p) => ReorderItem(
            product: p,
            ratio: p.minQuantity == 0
                ? 1
                : (p.currentQuantity / p.minQuantity).clamp(0.0, 1.0),
          ))
      .toList()
    ..sort((a, b) => a.ratio.compareTo(b.ratio));

  final inventoryValue = products.fold<double>(
    0,
    (sum, p) => sum + (p.purchasePrice * p.currentQuantity),
  );

  final todayFlow = _computeFlow(movements);

  final slowMovers = _slowMoverCount(products, movements);

  return AnalyticsSummary(
    health: StockHealthBreakdown(
      okCount: ok,
      lowCount: low,
      criticalCount: critical.length,
    ),
    criticalItems: critical,
    todayFlow: todayFlow,
    inventoryValue: inventoryValue,
    reorderQueue: reorderCandidates.take(3).toList(),
    slowMoverCount: slowMovers,
  );
});

FlowDelta _computeFlow(List<StockMovementModel> movements) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final todayMoves =
      movements.where((m) => _sameDay(m.createdAt, today)).toList();

  if (todayMoves.isNotEmpty) {
    return _aggregate(todayMoves, today, false);
  }

  if (movements.isEmpty) {
    return FlowDelta(
      unitsIn: 0,
      unitsOut: 0,
      referenceDay: today,
    );
  }

  final mostRecent =
      movements.map((m) => m.createdAt).reduce((a, b) => a.isAfter(b) ? a : b);
  final fallbackDay =
      DateTime(mostRecent.year, mostRecent.month, mostRecent.day);
  final fallbackMoves =
      movements.where((m) => _sameDay(m.createdAt, fallbackDay)).toList();
  return _aggregate(fallbackMoves, fallbackDay, true);
}

FlowDelta _aggregate(
  List<StockMovementModel> moves,
  DateTime day,
  bool fallback,
) {
  var inUnits = 0;
  var outUnits = 0;
  for (final m in moves) {
    switch (m.movementType) {
      case MovementType.inbound:
      case MovementType.returned:
        inUnits += m.quantity;
        break;
      case MovementType.outbound:
      case MovementType.damaged:
        outUnits += m.quantity;
        break;
      case MovementType.transfer:
      case MovementType.adjustment:
      case MovementType.inventory:
        break;
    }
  }
  return FlowDelta(
    unitsIn: inUnits,
    unitsOut: outUnits,
    referenceDay: day,
    fromFallback: fallback,
  );
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

int _slowMoverCount(
  List<ProductModel> products,
  List<StockMovementModel> movements,
) {
  final cutoff = DateTime.now().subtract(const Duration(days: 30));
  final recentlyMoved = movements
      .where((m) => m.createdAt.isAfter(cutoff))
      .map((m) => m.productId)
      .toSet();
  return products
      .where((p) => p.currentQuantity > 0 && !recentlyMoved.contains(p.id))
      .length;
}
