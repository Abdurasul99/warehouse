import 'package:equatable/equatable.dart';

class StockBalanceModel extends Equatable {
  final String id;
  final String productId;
  final String warehouseId;
  final int quantity;
  final DateTime updatedAt;

  const StockBalanceModel({
    required this.id,
    required this.productId,
    required this.warehouseId,
    required this.quantity,
    required this.updatedAt,
  });

  StockBalanceModel copyWith({
    String? id,
    String? productId,
    String? warehouseId,
    int? quantity,
    DateTime? updatedAt,
  }) =>
      StockBalanceModel(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        warehouseId: warehouseId ?? this.warehouseId,
        quantity: quantity ?? this.quantity,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'warehouse_id': warehouseId,
        'quantity': quantity,
        'updated_at': updatedAt.toIso8601String(),
      };

  factory StockBalanceModel.fromJson(Map<String, dynamic> json) => StockBalanceModel(
        id: json['id'] as String,
        productId: json['product_id'] as String,
        warehouseId: json['warehouse_id'] as String,
        quantity: json['quantity'] as int,
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  @override
  List<Object?> get props => [id, productId, warehouseId, quantity, updatedAt];
}
