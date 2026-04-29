import '../models/stock_balance_model.dart';

final List<StockBalanceModel> mockStockBalances = [
  StockBalanceModel(id: 'sb_001', productId: 'prod_001', warehouseId: 'wh_01', quantity: 100, updatedAt: DateTime(2025, 11, 10)),
  StockBalanceModel(id: 'sb_002', productId: 'prod_001', warehouseId: 'wh_02', quantity: 45, updatedAt: DateTime(2025, 11, 10)),
  StockBalanceModel(id: 'sb_003', productId: 'prod_002', warehouseId: 'wh_01', quantity: 8, updatedAt: DateTime(2025, 11, 10)),
  StockBalanceModel(id: 'sb_004', productId: 'prod_003', warehouseId: 'wh_01', quantity: 0, updatedAt: DateTime(2025, 11, 9)),
  StockBalanceModel(id: 'sb_005', productId: 'prod_004', warehouseId: 'wh_01', quantity: 52, updatedAt: DateTime(2025, 11, 8)),
  StockBalanceModel(id: 'sb_006', productId: 'prod_005', warehouseId: 'wh_01', quantity: 34, updatedAt: DateTime(2025, 11, 7)),
  StockBalanceModel(id: 'sb_007', productId: 'prod_006', warehouseId: 'wh_01', quantity: 12, updatedAt: DateTime(2025, 11, 6)),
  StockBalanceModel(id: 'sb_008', productId: 'prod_007', warehouseId: 'wh_01', quantity: 3, updatedAt: DateTime(2025, 11, 5)),
  StockBalanceModel(id: 'sb_009', productId: 'prod_008', warehouseId: 'wh_01', quantity: 89, updatedAt: DateTime(2025, 11, 4)),
  StockBalanceModel(id: 'sb_010', productId: 'prod_026', warehouseId: 'wh_01', quantity: 200, updatedAt: DateTime(2025, 10, 17)),
  StockBalanceModel(id: 'sb_011', productId: 'prod_026', warehouseId: 'wh_02', quantity: 120, updatedAt: DateTime(2025, 10, 17)),
];
