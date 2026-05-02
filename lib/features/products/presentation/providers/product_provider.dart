import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/category_model.dart';
import '../../../../shared/models/product_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/product_repository.dart';

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).maybeWhen(
        data: (user) => user?.id,
        orElse: () => null,
      );
});

final productRepositoryProvider = Provider<ProductRepository>(
  (_) => ProductRepositoryImpl(),
);

final productListProvider = AsyncNotifierProvider<ProductListNotifier, List<ProductModel>>(
  ProductListNotifier.new,
);

class ProductListNotifier extends AsyncNotifier<List<ProductModel>> {
  @override
  Future<List<ProductModel>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    final all = await ref.read(productRepositoryProvider).getAll();
    if (userId == null) return const [];
    return all.where((p) => p.ownerUserId == userId).toList();
  }

  Future<void> refresh() async {
    final userId = ref.read(currentUserIdProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final all = await ref.read(productRepositoryProvider).getAll();
      if (userId == null) return const <ProductModel>[];
      return all.where((p) => p.ownerUserId == userId).toList();
    });
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

  void setLowStock(bool value) =>
      state = state.copyWith(lowStockOnly: value);
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

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (_) => CategoryRepositoryImpl(),
);

final categoryListProvider =
    AsyncNotifierProvider<CategoryListNotifier, List<CategoryModel>>(
  CategoryListNotifier.new,
);

class CategoryListNotifier extends AsyncNotifier<List<CategoryModel>> {
  @override
  Future<List<CategoryModel>> build() {
    return ref.read(categoryRepositoryProvider).getAll();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(categoryRepositoryProvider).getAll(),
    );
  }

  Future<CategoryModel> createCategory({
    required String nameUz,
    required String nameRu,
  }) async {
    final repo = ref.read(categoryRepositoryProvider);
    final model = CategoryModel(
      id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
      nameUz: nameUz.trim(),
      nameRu: nameRu.trim(),
    );
    final created = await repo.create(model);
    final current = state.valueOrNull ?? const <CategoryModel>[];
    state = AsyncValue.data([...current, created]);
    return created;
  }
}

final productDetailProvider =
    FutureProvider.family<ProductModel?, String>((ref, id) async {
  return ref.watch(productRepositoryProvider).getById(id);
});
