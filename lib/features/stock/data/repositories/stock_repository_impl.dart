import '../../../../shared/mock_data/mock_database.dart';
import '../../../../shared/models/stock_balance_model.dart';
import '../../../../shared/models/stock_movement_model.dart';
import '../../domain/repositories/stock_repository.dart';

class StockRepositoryImpl implements StockRepository {
  final MockDatabase _db = MockDatabase();

  @override
  Future<StockBalanceModel?> getBalance(String productId, String warehouseId) async {
    try {
      return _db.stockBalances.firstWhere(
        (b) => b.productId == productId && b.warehouseId == warehouseId,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<StockMovementModel> createMovement(StockMovementModel movement) async {
    _db.movements.insert(0, movement);
    _setWarehouseBalance(
      productId: movement.productId,
      warehouseId: movement.warehouseId,
      quantity: movement.afterQuantity,
    );
    return movement;
  }

  void _setWarehouseBalance({
    required String productId,
    required String warehouseId,
    required int quantity,
  }) {
    final index = _db.stockBalances.indexWhere(
      (b) => b.productId == productId && b.warehouseId == warehouseId,
    );
    final updatedAt = DateTime.now();

    if (index == -1) {
      _db.stockBalances.add(
        StockBalanceModel(
          id: 'sb_${productId}_$warehouseId',
          productId: productId,
          warehouseId: warehouseId,
          quantity: quantity,
          updatedAt: updatedAt,
        ),
      );
      return;
    }

    _db.stockBalances[index] = _db.stockBalances[index].copyWith(
      quantity: quantity,
      updatedAt: updatedAt,
    );
  }
}
