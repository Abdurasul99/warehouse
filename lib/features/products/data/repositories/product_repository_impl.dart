import '../../../../shared/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

// MVP1: read-only against sales-system server. Mutations are not yet implemented
// against the server and would silently no-op or corrupt local UI state, so we throw.
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remote;
  final List<ProductModel> _cache = [];

  ProductRepositoryImpl(this._remote);

  @override
  Future<List<ProductModel>> getAll() async {
    final list = await _remote.getAll();
    _cache
      ..clear()
      ..addAll(list);
    return List.unmodifiable(list);
  }

  @override
  Future<ProductModel?> getById(String id) async {
    final fromCache = _cache.where((p) => p.id == id).toList();
    if (fromCache.isNotEmpty) return fromCache.first;
    return _remote.getById(id);
  }

  @override
  Future<ProductModel> create(ProductModel product) =>
      throw UnimplementedError('Создание товаров пока недоступно с мобильного');

  @override
  Future<ProductModel> update(ProductModel product) =>
      throw UnimplementedError('Редактирование товаров пока недоступно с мобильного');

  @override
  Future<void> delete(String id) =>
      throw UnimplementedError('Удаление товаров пока недоступно с мобильного');

  @override
  Future<void> updateQuantity(String id, int newQuantity) =>
      throw UnimplementedError('Изменение остатков пока недоступно с мобильного');

  @override
  Future<bool> isSkuUnique(String sku, {String? excludeId}) async {
    final list = _cache.isNotEmpty ? _cache : await getAll();
    return !list.any((p) => p.sku == sku && p.id != excludeId);
  }
}
