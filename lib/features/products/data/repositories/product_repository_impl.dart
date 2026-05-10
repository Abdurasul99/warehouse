import '../../../../shared/mock_data/mock_database.dart';
import '../../../../shared/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final MockDatabase _db = MockDatabase();

  @override
  Future<List<ProductModel>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_db.products);
  }

  @override
  Future<ProductModel?> getById(String id) async {
    try {
      return _db.products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ProductModel> create(ProductModel product) async {
    _db.products.add(product);
    return product;
  }

  @override
  Future<ProductModel> update(ProductModel product) async {
    final index = _db.products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _db.products[index] = product;
    }
    return product;
  }

  @override
  Future<void> delete(String id) async {
    _db.products.removeWhere((p) => p.id == id);
  }

  @override
  Future<void> updateQuantity(String id, int newQuantity) async {
    final index = _db.products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _db.products[index] = _db.products[index].copyWith(
        currentQuantity: newQuantity,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<bool> isSkuUnique(String sku, {String? excludeId}) async {
    return !_db.products.any(
      (p) => p.sku == sku && p.id != excludeId,
    );
  }
}
