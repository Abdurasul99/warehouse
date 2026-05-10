import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/models/product_model.dart';

class ProductRemoteDataSource {
  final ApiClient _api;
  ProductRemoteDataSource(this._api);

  Future<List<ProductModel>> getAll({int page = 1, int limit = 200, String? search}) async {
    final res = await _api.get(ApiConfig.products, query: {
      'page': page,
      'limit': limit,
      if (search != null && search.isNotEmpty) 'q': search,
    });
    // New backend: { items: [...], total }. Legacy backend: { data: [...] }.
    final list = res is Map
        ? (res['items'] is List
            ? res['items'] as List
            : (res['data'] is List ? res['data'] as List : const []))
        : const [];
    return list
        .whereType<Map>()
        .map((m) => ProductModel.fromServerJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  Future<ProductModel?> getById(String id) async {
    try {
      final res = await _api.get('${ApiConfig.products}/$id');
      if (res is Map<String, dynamic>) return ProductModel.fromServerJson(res);
      if (res is Map) return ProductModel.fromServerJson(Map<String, dynamic>.from(res));
      return null;
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }
}
