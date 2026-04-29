import '../../../../shared/models/stock_balance_model.dart';
import '../../../../shared/models/stock_movement_model.dart';

abstract class StockRepository {
  Future<StockBalanceModel?> getBalance(String productId, String warehouseId);
  Future<StockMovementModel> createMovement(StockMovementModel movement);
}
