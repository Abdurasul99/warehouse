import '../../../../shared/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getAll();
  Future<ProductModel?> getById(String id);
  Future<ProductModel> create(ProductModel product);
  Future<ProductModel> update(ProductModel product);
  Future<void> delete(String id);
  Future<void> updateQuantity(String id, int newQuantity);
  Future<bool> isSkuUnique(String sku, {String? excludeId});
}
