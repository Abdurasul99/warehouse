import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/category_model.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/mock_data/mock_database.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (_) => ProductRepositoryImpl(),
);

final productListProvider = AsyncNotifierProvider<ProductListNotifier, List<ProductModel>>(
  ProductListNotifier.new,
);

class ProductListNotifier extends AsyncNotifier<List<ProductModel>> {
  @override
  Future<List<ProductModel>> build() async {
    return ref.read(productRepositoryProvider).getAll();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(productRepositoryProvider).getAll());
  }

  Future<bool> delete(String id) async {
    try {
      await ref.read(productRepositoryProvider).delete(id);
      state = AsyncValue.data(
        state.requireValue.where((p) => p.id != id).toList(),
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}

class ProductFilter {
  final String searchQuery;
  final String? categoryId;
  final bool lowStockOnly;

  const ProductFilter({
    this.searchQuery = '',
    this.categoryId,
    this.lowStockOnly = false,
  });

  ProductFilter copyWith({
    String? searchQuery,
    String? categoryId,
    bool clearCategory = false,
    bool? lowStockOnly,
  }) =>
      ProductFilter(
        searchQuery: searchQuery ?? this.searchQuery,
        categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
        lowStockOnly: lowStockOnly ?? this.lowStockOnly,
      );
}

final productFilterProvider = NotifierProvider<ProductFilterNotifier, ProductFilter>(
  ProductFilterNotifier.new,
);

class ProductFilterNotifier extends Notifier<ProductFilter> {
  @override
  ProductFilter build() => const ProductFilter();

  void setSearch(String query) => state = state.copyWith(searchQuery: query);
  void setCategory(String? id) {
    if (id == null) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(categoryId: id);
    }
  }

  void toggleLowStock() =>
      state = state.copyWith(lowStockOnly: !state.lowStockOnly);
}

final filteredProductsProvider = Provider<AsyncValue<List<ProductModel>>>((ref) {
  final listAsync = ref.watch(productListProvider);
  final filter = ref.watch(productFilterProvider);

  return listAsync.whenData((products) {
    var result = products;
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      result = result
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.sku.toLowerCase().contains(q) ||
              (p.barcode?.toLowerCase().contains(q) ?? false))
          .toList();
    }
    if (filter.categoryId != null) {
      result = result.where((p) => p.categoryId == filter.categoryId).toList();
    }
    if (filter.lowStockOnly) {
      result = result
          .where((p) =>
              p.currentQuantity <= p.minQuantity)
          .toList();
    }
    return result;
  });
});

final categoryListProvider = FutureProvider<List<CategoryModel>>((ref) async {
  return List.from(MockDatabase().categories);
});

final productDetailProvider =
    FutureProvider.family<ProductModel?, String>((ref, id) async {
  return ref.watch(productRepositoryProvider).getById(id);
});
