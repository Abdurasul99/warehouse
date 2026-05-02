import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales_system_warehouse_mobile/core/utils/enums.dart';
import 'package:sales_system_warehouse_mobile/features/dashboard/domain/analytics_summary.dart';
import 'package:sales_system_warehouse_mobile/features/dashboard/presentation/providers/analytics_provider.dart';
import 'package:sales_system_warehouse_mobile/features/products/presentation/providers/product_provider.dart';
import 'package:sales_system_warehouse_mobile/shared/mock_data/mock_database.dart';
import 'package:sales_system_warehouse_mobile/shared/models/product_model.dart';
import 'package:sales_system_warehouse_mobile/shared/models/stock_movement_model.dart';

ProductModel _makeProduct({
  required String id,
  required String ownerId,
  int qty = 50,
  int min = 10,
  double price = 100,
}) {
  final now = DateTime(2026, 5, 1);
  return ProductModel(
    id: id,
    name: 'Product $id',
    sku: 'SKU-$id',
    categoryId: 'cat_01',
    unit: 'dona',
    purchasePrice: price,
    sellingPrice: price * 1.5,
    currentQuantity: qty,
    minQuantity: min,
    ownerUserId: ownerId,
    createdAt: now,
    updatedAt: now,
  );
}

ProviderContainer _container({String? userId}) {
  return ProviderContainer(
    overrides: [
      currentUserIdProvider.overrideWithValue(userId),
    ],
  );
}

void main() {
  setUp(() {
    final db = MockDatabase();
    db.users = [];
    db.categories = [];
    db.products = [];
    db.warehouses = [];
    db.stockBalances = [];
    db.movements = [];
  });

  tearDownAll(() {
    MockDatabase().reset();
  });

  group('analyticsSummaryProvider', () {
    test('returns empty summary for unauthenticated user', () async {
      final container = _container(userId: null);
      addTearDown(container.dispose);

      final summary =
          await container.read(analyticsSummaryProvider.future);

      expect(summary.totalProducts, 0);
      expect(summary.isEmpty, true);
      expect(summary.health.total, 0);
      expect(summary.criticalItems, isEmpty);
      expect(summary.reorderQueue, isEmpty);
      expect(summary.inventoryValue, 0);
    });

    test('isolates products by ownerUserId', () async {
      MockDatabase().products = [
        _makeProduct(id: 'a', ownerId: 'usr_01', qty: 100),
        _makeProduct(id: 'b', ownerId: 'usr_02', qty: 5, min: 10),
      ];

      final container = _container(userId: 'usr_02');
      addTearDown(container.dispose);

      final summary =
          await container.read(analyticsSummaryProvider.future);

      expect(summary.totalProducts, 1);
      expect(summary.health.lowCount, 1);
      expect(summary.health.okCount, 0);
      expect(summary.criticalItems, isEmpty);
    });

    test('counts critical (zero quantity) products', () async {
      MockDatabase().products = [
        _makeProduct(id: 'a', ownerId: 'u', qty: 0),
        _makeProduct(id: 'b', ownerId: 'u', qty: 50),
      ];

      final container = _container(userId: 'u');
      addTearDown(container.dispose);

      final summary =
          await container.read(analyticsSummaryProvider.future);

      expect(summary.health.criticalCount, 1);
      expect(summary.criticalItems.first.id, 'a');
    });

    test('inventory value is purchasePrice × quantity', () async {
      MockDatabase().products = [
        _makeProduct(id: 'a', ownerId: 'u', qty: 10, price: 200),
        _makeProduct(id: 'b', ownerId: 'u', qty: 5, price: 50),
      ];

      final container = _container(userId: 'u');
      addTearDown(container.dispose);

      final summary =
          await container.read(analyticsSummaryProvider.future);

      expect(summary.inventoryValue, 10 * 200 + 5 * 50);
    });

    test('reorder queue is sorted by ratio ascending and capped at 3',
        () async {
      MockDatabase().products = [
        _makeProduct(id: 'a', ownerId: 'u', qty: 8, min: 10),
        _makeProduct(id: 'b', ownerId: 'u', qty: 0, min: 5),
        _makeProduct(id: 'c', ownerId: 'u', qty: 3, min: 10),
        _makeProduct(id: 'd', ownerId: 'u', qty: 2, min: 10),
        _makeProduct(id: 'e', ownerId: 'u', qty: 99, min: 10),
      ];

      final container = _container(userId: 'u');
      addTearDown(container.dispose);

      final summary =
          await container.read(analyticsSummaryProvider.future);

      expect(summary.reorderQueue.length, 3);
      expect(summary.reorderQueue.first.product.id, 'b');
      expect(summary.reorderQueue.first.ratio, 0);
    });

    test('today flow aggregates inbound minus outbound for owned products',
        () async {
      final today = DateTime.now();
      MockDatabase().products = [
        _makeProduct(id: 'a', ownerId: 'u'),
      ];
      MockDatabase().movements = [
        StockMovementModel(
          id: 'm1',
          productId: 'a',
          warehouseId: 'w1',
          movementType: MovementType.inbound,
          quantity: 10,
          beforeQuantity: 0,
          afterQuantity: 10,
          createdBy: 'u',
          createdAt: today,
        ),
        StockMovementModel(
          id: 'm2',
          productId: 'a',
          warehouseId: 'w1',
          movementType: MovementType.outbound,
          quantity: 3,
          beforeQuantity: 10,
          afterQuantity: 7,
          createdBy: 'u',
          createdAt: today,
        ),
      ];

      final container = _container(userId: 'u');
      addTearDown(container.dispose);

      final summary =
          await container.read(analyticsSummaryProvider.future);

      expect(summary.todayFlow.unitsIn, 10);
      expect(summary.todayFlow.unitsOut, 3);
      expect(summary.todayFlow.net, 7);
      expect(summary.todayFlow.fromFallback, false);
    });

    test('today flow falls back to last active day when today is empty',
        () async {
      final lastActive = DateTime.now().subtract(const Duration(days: 5));
      MockDatabase().products = [
        _makeProduct(id: 'a', ownerId: 'u'),
      ];
      MockDatabase().movements = [
        StockMovementModel(
          id: 'm1',
          productId: 'a',
          warehouseId: 'w1',
          movementType: MovementType.inbound,
          quantity: 4,
          beforeQuantity: 0,
          afterQuantity: 4,
          createdBy: 'u',
          createdAt: lastActive,
        ),
      ];

      final container = _container(userId: 'u');
      addTearDown(container.dispose);

      final summary =
          await container.read(analyticsSummaryProvider.future);

      expect(summary.todayFlow.fromFallback, true);
      expect(summary.todayFlow.unitsIn, 4);
    });
  });

  group('StockHealthBreakdown', () {
    test('level is green when ≥70% ok', () {
      final h = StockHealthBreakdown(okCount: 7, lowCount: 2, criticalCount: 1);
      expect(h.level, HealthLevel.green);
    });
    test('level is yellow when 40-70% ok', () {
      final h = StockHealthBreakdown(okCount: 5, lowCount: 5, criticalCount: 0);
      expect(h.level, HealthLevel.yellow);
    });
    test('level is red when <40% ok', () {
      final h = StockHealthBreakdown(okCount: 2, lowCount: 5, criticalCount: 3);
      expect(h.level, HealthLevel.red);
    });
    test('level is green for empty (no products)', () {
      final h = StockHealthBreakdown(okCount: 0, lowCount: 0, criticalCount: 0);
      expect(h.level, HealthLevel.green);
    });
  });

  group('FlowDelta', () {
    test('green for positive net', () {
      expect(
        FlowDelta(
          unitsIn: 10,
          unitsOut: 3,
          referenceDay: DateTime.now(),
        ).level,
        HealthLevel.green,
      );
    });
    test('yellow for zero net', () {
      expect(
        FlowDelta(
          unitsIn: 5,
          unitsOut: 5,
          referenceDay: DateTime.now(),
        ).level,
        HealthLevel.yellow,
      );
    });
    test('red for negative net', () {
      expect(
        FlowDelta(
          unitsIn: 0,
          unitsOut: 7,
          referenceDay: DateTime.now(),
        ).level,
        HealthLevel.red,
      );
    });
  });
}
