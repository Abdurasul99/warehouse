import '../models/stock_movement_model.dart';
import '../../core/utils/enums.dart';

final List<StockMovementModel> mockMovements = [
  StockMovementModel(
    id: 'mv_001', productId: 'prod_001', warehouseId: 'wh_01',
    movementType: MovementType.inbound, quantity: 50, beforeQuantity: 95, afterQuantity: 145,
    note: "Etkazib beruvchidan qabul qilindi", createdBy: 'usr_02',
    createdAt: DateTime(2025, 11, 10, 9, 30),
    productName: "Yog'och qoshiq (katta)", warehouseName: 'Asosiy ombor', createdByName: 'Mansur Yusupov',
  ),
  StockMovementModel(
    id: 'mv_002', productId: 'prod_026', warehouseId: 'wh_01',
    movementType: MovementType.outbound, quantity: 30, beforeQuantity: 350, afterQuantity: 320,
    reason: 'Sale', note: "Do'konga jo'natildi", createdBy: 'usr_03',
    createdAt: DateTime(2025, 11, 10, 11, 15),
    productName: 'Magnit (Registon, kichik)', warehouseName: 'Asosiy ombor', createdByName: 'Sherzod Toshmatov',
  ),
  StockMovementModel(
    id: 'mv_003', productId: 'prod_003', warehouseId: 'wh_01',
    movementType: MovementType.outbound, quantity: 5, beforeQuantity: 5, afterQuantity: 0,
    reason: 'Damaged', note: "Zararlangan mahsulotlar olib tashlandi", createdBy: 'usr_02',
    createdAt: DateTime(2025, 11, 9, 14, 0),
    productName: "Yog'och quti (kichik)", warehouseName: 'Asosiy ombor', createdByName: 'Mansur Yusupov',
  ),
  StockMovementModel(
    id: 'mv_004', productId: 'prod_008', warehouseId: 'wh_01',
    movementType: MovementType.inbound, quantity: 100, beforeQuantity: 0, afterQuantity: 89,
    note: "Yangi partiya keldi", createdBy: 'usr_01',
    createdAt: DateTime(2025, 11, 8, 10, 0),
    productName: "Keramika piyola (ko'k naqsh)", warehouseName: 'Asosiy ombor', createdByName: 'Admin Adminov',
  ),
  StockMovementModel(
    id: 'mv_005', productId: 'prod_015', warehouseId: 'wh_01',
    movementType: MovementType.adjustment, quantity: 6, beforeQuantity: 50, afterQuantity: 56,
    note: "Inventarizatsiya natijasi", createdBy: 'usr_02',
    createdAt: DateTime(2025, 11, 7, 16, 30),
    productName: 'Doppi (qora)', warehouseName: 'Asosiy ombor', createdByName: 'Mansur Yusupov',
  ),
  StockMovementModel(
    id: 'mv_006', productId: 'prod_017', warehouseId: 'wh_01',
    movementType: MovementType.inbound, quantity: 20, beforeQuantity: 13, afterQuantity: 33,
    note: "Usta ustaxonadan topshirdi", createdBy: 'usr_03',
    createdAt: DateTime(2025, 11, 6, 9, 0),
    productName: 'Milliy pichoq (kichik)', warehouseName: 'Asosiy ombor', createdByName: 'Sherzod Toshmatov',
  ),
  StockMovementModel(
    id: 'mv_007', productId: 'prod_029', warehouseId: 'wh_01',
    movementType: MovementType.outbound, quantity: 4, beforeQuantity: 20, afterQuantity: 16,
    reason: 'Sale', createdBy: 'usr_03',
    createdAt: DateTime(2025, 11, 5, 13, 45),
    productName: "Teri sumka (qo'l sumkasi)", warehouseName: 'Asosiy ombor', createdByName: 'Sherzod Toshmatov',
  ),
];
