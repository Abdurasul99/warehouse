import '../models/user_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/warehouse_model.dart';
import '../models/stock_balance_model.dart';
import '../models/stock_movement_model.dart';
import 'mock_users.dart';
import 'mock_categories.dart';
import 'mock_products.dart';
import 'mock_warehouses.dart';
import 'mock_stock_balances.dart';
import 'mock_movements.dart';

class MockDatabase {
  static final MockDatabase _instance = MockDatabase._internal();
  factory MockDatabase() => _instance;
  MockDatabase._internal();

  late List<UserModel> users;
  late List<CategoryModel> categories;
  late List<ProductModel> products;
  late List<WarehouseModel> warehouses;
  late List<StockBalanceModel> stockBalances;
  late List<StockMovementModel> movements;
  bool _initialized = false;

  void initialize() {
    if (_initialized) return;
    users = List.from(mockUsers);
    categories = List.from(mockCategories);
    products = List.from(mockProducts);
    warehouses = List.from(mockWarehouses);
    stockBalances = List.from(mockStockBalances);
    movements = List.from(mockMovements);
    _initialized = true;
  }

  void reset() {
    _initialized = false;
    initialize();
  }
}
