import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../shared/models/product_model.dart';
import 'product_provider.dart';

class ProductFormState {
  final String? id;
  final String name;
  final String sku;
  final String barcode;
  final String categoryId;
  final String description;
  final String unit;
  final String purchasePrice;
  final String sellingPrice;
  final String currentQuantity;
  final String minQuantity;
  final String photoPath;
  final bool isSubmitting;
  final String? errorMessage;
  final bool success;

  const ProductFormState({
    this.id,
    this.name = '',
    this.sku = '',
    this.barcode = '',
    this.categoryId = '',
    this.description = '',
    this.unit = 'dona',
    this.purchasePrice = '',
    this.sellingPrice = '',
    this.currentQuantity = '0',
    this.minQuantity = '10',
    this.photoPath = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.success = false,
  });

  ProductFormState copyWith({
    String? id,
    String? name,
    String? sku,
    String? barcode,
    String? categoryId,
    String? description,
    String? unit,
    String? purchasePrice,
    String? sellingPrice,
    String? currentQuantity,
    String? minQuantity,
    String? photoPath,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    bool? success,
  }) =>
      ProductFormState(
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
        photoPath: photoPath ?? this.photoPath,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        success: success ?? this.success,
      );

  factory ProductFormState.fromProduct(ProductModel p) => ProductFormState(
        id: p.id,
        name: p.name,
        sku: p.sku,
        barcode: p.barcode ?? '',
        categoryId: p.categoryId,
        description: p.description ?? '',
        unit: p.unit,
        purchasePrice: p.purchasePrice.toStringAsFixed(0),
        sellingPrice: p.sellingPrice.toStringAsFixed(0),
        currentQuantity: p.currentQuantity.toString(),
        minQuantity: p.minQuantity.toString(),
        photoPath: p.imagePlaceholder ?? '',
      );
}

final productFormProvider =
    NotifierProvider.family<ProductFormNotifier, ProductFormState, String?>(
  ProductFormNotifier.new,
);

class ProductFormNotifier extends FamilyNotifier<ProductFormState, String?> {
  @override
  ProductFormState build(String? arg) {
    if (arg == null) return const ProductFormState();
    final product = ref
        .read(productListProvider)
        .maybeWhen(data: (list) => list.where((p) => p.id == arg).firstOrNull, orElse: () => null);
    return product != null
        ? ProductFormState.fromProduct(product)
        : const ProductFormState();
  }

  void update(ProductFormState Function(ProductFormState) updater) {
    state = updater(state);
  }

  Future<bool> submit() async {
    if (state.name.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Mahsulot nomi majburiy');
      return false;
    }
    if (state.categoryId.isEmpty) {
      state = state.copyWith(errorMessage: 'Kategoriya tanlang');
      return false;
    }
    if (state.sku.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'SKU majburiy');
      return false;
    }
    final isNew = state.id == null;
    final qty = int.tryParse(state.currentQuantity) ?? 0;
    if (isNew && qty == 0 && state.photoPath.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Yangi mahsulot uchun fotosurat majburiy',
      );
      return false;
    }

    final repo = ref.read(productRepositoryProvider);
    final isUnique = await repo.isSkuUnique(state.sku.trim(), excludeId: state.id);
    if (!isUnique) {
      state = state.copyWith(errorMessage: 'Bu SKU allaqachon mavjud');
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    final existingProduct = state.id == null ? null : await repo.getById(state.id!);
    final now = DateTime.now();
    final product = ProductModel(
      id: state.id ?? const Uuid().v4(),
      name: state.name.trim(),
      sku: state.sku.trim(),
      barcode: state.barcode.trim().isEmpty ? null : state.barcode.trim(),
      categoryId: state.categoryId,
      description: state.description.trim().isEmpty ? null : state.description.trim(),
      unit: state.unit,
      purchasePrice: double.tryParse(state.purchasePrice) ?? 0,
      sellingPrice: double.tryParse(state.sellingPrice) ?? 0,
      currentQuantity: int.tryParse(state.currentQuantity) ?? 0,
      minQuantity: int.tryParse(state.minQuantity) ?? 10,
      imagePlaceholder: state.photoPath.isEmpty ? null : state.photoPath,
      createdAt: existingProduct?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      if (state.id == null) {
        await repo.create(product);
      } else {
        await repo.update(product);
      }
      await ref.read(productListProvider.notifier).refresh();
      state = state.copyWith(isSubmitting: false, success: true);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }
}
