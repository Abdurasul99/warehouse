import '../../../../shared/models/stock_movement_model.dart';

abstract class MovementRepository {
  Future<List<StockMovementModel>> getAll();
  Future<StockMovementModel> create(StockMovementModel movement);
}
