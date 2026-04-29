import '../../../../shared/mock_data/mock_database.dart';
import '../../../../shared/models/stock_movement_model.dart';
import '../../domain/repositories/movement_repository.dart';

class MovementRepositoryImpl implements MovementRepository {
  final MockDatabase _db = MockDatabase();

  @override
  Future<List<StockMovementModel>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.from(_db.movements);
  }

  @override
  Future<StockMovementModel> create(StockMovementModel movement) async {
    _db.movements.insert(0, movement);
    return movement;
  }
}
