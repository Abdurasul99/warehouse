import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/enums.dart';
import '../../../../shared/mock_data/mock_database.dart';
import '../../../../shared/models/stock_movement_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../movements/presentation/providers/movement_provider.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../../../stock/data/repositories/stock_repository_impl.dart';

class InventorySession {
  final Map<String, int?> actualCounts;
  final bool isSubmitting;
  final bool success;
  final String? error;

  const InventorySession({
    this.actualCounts = const {},
    this.isSubmitting = false,
    this.success = false,
    this.error,
  });

  InventorySession copyWith({
    Map<String, int?>? actualCounts,
    bool? isSubmitting,
    bool? success,
    String? error,
    bool clearError = false,
  }) =>
      InventorySession(
        actualCounts: actualCounts ?? this.actualCounts,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        success: success ?? this.success,
        error: clearError ? null : (error ?? this.error),
      );
}

final inventoryProvider =
    NotifierProvider<InventoryNotifier, InventorySession>(InventoryNotifier.new);

class InventoryNotifier extends Notifier<InventorySession> {
  @override
  InventorySession build() => const InventorySession();

  void setActualCount(String productId, int? count) {
    final updated = Map<String, int?>.from(state.actualCounts);
    updated[productId] = count;
    state = state.copyWith(actualCounts: updated);
  }

  int? getActual(String productId) => state.actualCounts[productId];

  int diffFor(String productId, int expected) {
    final actual = state.actualCounts[productId];
    if (actual == null) return 0;
    return actual - expected;
  }

  Future<bool> submit(String warehouseId) async {
    final db = MockDatabase();
    final stockRepository = StockRepositoryImpl();
    final user = ref.read(authProvider).maybeWhen(data: (u) => u, orElse: () => null);

    final diffs = <({dynamic product, int actual, int before, int diff})>[];
    for (final entry in state.actualCounts.entries.where((e) => e.value != null)) {
      final product = db.products.where((p) => p.id == entry.key).firstOrNull;
      if (product == null) continue;

      final balance = await stockRepository.getBalance(product.id, warehouseId);
      final before = balance?.quantity ?? 0;
      final diff = entry.value! - before;
      if (diff == 0) continue;
      diffs.add((product: product, actual: entry.value!, before: before, diff: diff));
    }

    if (diffs.isEmpty) {
      state = state.copyWith(error: 'Farq yo\'q - saqlash shart emas');
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    for (final item in diffs) {
      final movement = StockMovementModel(
        id: const Uuid().v4(),
        productId: item.product.id,
        warehouseId: warehouseId,
        movementType: MovementType.adjustment,
        quantity: item.diff.abs(),
        beforeQuantity: item.before,
        afterQuantity: item.actual,
        note: 'Inventarizatsiya',
        createdBy: user?.id ?? 'unknown',
        createdAt: DateTime.now(),
        productName: item.product.name,
        warehouseName: db.warehouses.where((w) => w.id == warehouseId)
            .map((w) => w.name).firstOrNull,
        createdByName: user?.name,
      );
      await stockRepository.createMovement(movement);
      final currentProduct = db.products.where((p) => p.id == item.product.id).firstOrNull;
      await ref.read(productRepositoryProvider).updateQuantity(
            item.product.id,
            (currentProduct?.currentQuantity ?? item.product.currentQuantity) + item.diff,
          );
    }

    ref.invalidate(productListProvider);
    ref.invalidate(movementListProvider);

    state = state.copyWith(isSubmitting: false, success: true);
    return true;
  }

  void reset() => state = const InventorySession();
}
