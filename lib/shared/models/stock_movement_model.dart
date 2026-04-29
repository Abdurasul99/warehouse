import 'package:equatable/equatable.dart';
import '../../core/utils/enums.dart';

class StockMovementModel extends Equatable {
  final String id;
  final String productId;
  final String warehouseId;
  final MovementType movementType;
  final int quantity;
  final int beforeQuantity;
  final int afterQuantity;
  final String? reason;
  final String? note;
  final String createdBy;
  final DateTime createdAt;
  final String? productName;
  final String? warehouseName;
  final String? createdByName;

  const StockMovementModel({
    required this.id,
    required this.productId,
    required this.warehouseId,
    required this.movementType,
    required this.quantity,
    required this.beforeQuantity,
    required this.afterQuantity,
    this.reason,
    this.note,
    required this.createdBy,
    required this.createdAt,
    this.productName,
    this.warehouseName,
    this.createdByName,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'warehouse_id': warehouseId,
        'movement_type': movementType.dbValue,
        'quantity': quantity,
        'before_quantity': beforeQuantity,
        'after_quantity': afterQuantity,
        'reason': reason,
        'note': note,
        'created_by': createdBy,
        'created_at': createdAt.toIso8601String(),
      };

  factory StockMovementModel.fromJson(Map<String, dynamic> json) => StockMovementModel(
        id: json['id'] as String,
        productId: json['product_id'] as String,
        warehouseId: json['warehouse_id'] as String,
        movementType: movementTypeFromDbValue(json['movement_type'] as String),
        quantity: json['quantity'] as int,
        beforeQuantity: json['before_quantity'] as int,
        afterQuantity: json['after_quantity'] as int,
        reason: json['reason'] as String?,
        note: json['note'] as String?,
        createdBy: json['created_by'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  @override
  List<Object?> get props => [id, productId, movementType, quantity, createdAt];
}
