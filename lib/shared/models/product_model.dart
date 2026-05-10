import 'package:equatable/equatable.dart';
import '../../core/utils/enums.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String sku;
  final String? barcode;
  final String categoryId;
  final String? description;
  final String unit;
  final double purchasePrice;
  final double sellingPrice;
  final int currentQuantity;
  final int minQuantity;
  final String? imagePlaceholder;
  final String ownerUserId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    this.barcode,
    required this.categoryId,
    this.description,
    required this.unit,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.currentQuantity,
    required this.minQuantity,
    this.imagePlaceholder,
    this.ownerUserId = 'usr_01',
    required this.createdAt,
    required this.updatedAt,
  });

  StockStatus get stockStatus {
    if (currentQuantity <= 0) return StockStatus.critical;
    if (currentQuantity <= minQuantity) return StockStatus.low;
    return StockStatus.ok;
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? sku,
    String? barcode,
    String? categoryId,
    String? description,
    String? unit,
    double? purchasePrice,
    double? sellingPrice,
    int? currentQuantity,
    int? minQuantity,
    String? imagePlaceholder,
    String? ownerUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        sku: sku ?? this.sku,
        barcode: barcode ?? this.barcode,
        categoryId: categoryId ?? this.categoryId,
        description: description ?? this.description,
        unit: unit ?? this.unit,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        sellingPrice: sellingPrice ?? this.sellingPrice,
        currentQuantity: currentQuantity ?? this.currentQuantity,
        minQuantity: minQuantity ?? this.minQuantity,
        imagePlaceholder: imagePlaceholder ?? this.imagePlaceholder,
        ownerUserId: ownerUserId ?? this.ownerUserId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sku': sku,
        'barcode': barcode,
        'category_id': categoryId,
        'description': description,
        'unit': unit,
        'purchase_price': purchasePrice,
        'selling_price': sellingPrice,
        'current_quantity': currentQuantity,
        'min_quantity': minQuantity,
        'image_placeholder': imagePlaceholder,
        'owner_user_id': ownerUserId,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as String,
        name: json['name'] as String,
        sku: json['sku'] as String,
        barcode: json['barcode'] as String?,
        categoryId: json['category_id'] as String,
        description: json['description'] as String?,
        unit: json['unit'] as String,
        purchasePrice: (json['purchase_price'] as num).toDouble(),
        sellingPrice: (json['selling_price'] as num).toDouble(),
        currentQuantity: json['current_quantity'] as int,
        minQuantity: json['min_quantity'] as int,
        imagePlaceholder: json['image_placeholder'] as String?,
        ownerUserId: json['owner_user_id'] as String? ?? 'usr_01',
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  // Maps product from sales-system /api/products response.
  // Site fields: costPrice, sellingPrice, categoryId, minStockLevel, imageUrl,
  // inventory: [{ quantity }] (one row per branch — sum across branches for total).
  factory ProductModel.fromServerJson(Map<String, dynamic> json) {
    // Stock: new backend exposes flat `stock`; legacy backend uses `inventory[]`.
    int currentQty;
    if (json['stock'] is num) {
      currentQty = (json['stock'] as num).toInt();
    } else {
      final inventoryList = (json['inventory'] as List?) ?? const [];
      final totalQty = inventoryList.fold<num>(
        0,
        (sum, inv) =>
            sum + ((inv is Map && inv['quantity'] is num) ? inv['quantity'] as num : 0),
      );
      currentQty = totalQty.toInt();
    }

    // Pricing: new backend has single `price` (selling). Legacy has cost+selling.
    final selling = ((json['sellingPrice'] as num?) ??
            (json['price'] as num?) ??
            0)
        .toDouble();
    final purchase = ((json['costPrice'] as num?) ?? selling).toDouble();

    final categoryValue = (json['categoryId'] as String?) ??
        (json['category'] as String?) ??
        '';

    return ProductModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: json['name'] as String,
      sku: (json['sku'] as String?) ?? '',
      barcode: json['barcode'] as String?,
      categoryId: categoryValue,
      description: json['description'] as String?,
      unit: (json['unit'] as String?) ?? 'шт',
      purchasePrice: purchase,
      sellingPrice: selling,
      currentQuantity: currentQty,
      minQuantity: ((json['minStockLevel'] as num?) ?? 0).toInt(),
      imagePlaceholder: json['imageUrl'] as String?,
      ownerUserId: (json['organizationId'] as String?) ??
          (json['createdBy'] as String?) ??
          'org_01',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, sku, currentQuantity, updatedAt];
}
