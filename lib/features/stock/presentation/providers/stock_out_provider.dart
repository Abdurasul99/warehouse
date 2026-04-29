import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/enums.dart';
import '../../../../shared/models/stock_movement_model.dart';
import '../../../../shared/mock_data/mock_database.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../movements/presentation/providers/movement_provider.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../../data/repositories/stock_repository_impl.dart';

class StockOutFormState {
  final String? productId;
  final String? warehouseId;
  final String quantity;
  final String reason;
  final String note;
  final bool isSubmitting;
  final String? error;
  final bool success;

  const StockOutFormState({
    this.productId,
    this.warehouseId,
    this.quantity = '',
    this.reason = '',
    this.note = '',
    this.isSubmitting = false,
    this.error,
    this.success = false,
  });

  StockOutFormState copyWith({
    String? productId,
    String? warehouseId,
    String? quantity,
    String? reason,
    String? note,
    bool? isSubmitting,
    String? error,
    bool clearError = false,
    bool? success,
  }) =>
      StockOutFormState(
        productId: productId ?? this.productId,
        warehouseId: warehouseId ?? this.warehouseId,
        quantity: quantity ?? this.quantity,
        reason: reason ?? this.reason,
        note: note ?? this.note,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        error: clearError ? null : (error ?? this.error),
        success: success ?? this.success,
      );
}

final stockOutProvider =
    NotifierProvider<StockOutNotifier, StockOutFormState>(StockOutNotifier.new);

class StockOutNotifier extends Notifier<StockOutFormState> {
  @override
  StockOutFormState build() => const StockOutFormState();

  void setProduct(String? id) => state = state.copyWith(productId: id, clearError: true);
  void setWarehouse(String? id) => state = state.copyWith(warehouseId: id);
  void setQuantity(String qty) => state = state.copyWith(quantity: qty, clearError: true);
  void setReason(String reason) => state = state.copyWith(reason: reason);
  void setNote(String note) => state = state.copyWith(note: note);

  Future<bool> submit() async {
    final qty = int.tryParse(state.quantity.trim()) ?? 0;
    if (state.productId == null) {
      state = state.copyWith(error: 'Mahsulot tanlang');
      return false;
    }
    if (state.warehouseId == null) {
      state = state.copyWith(error: 'Ombor tanlang');
      return false;
    }
    if (qty <= 0) {
      state = state.copyWith(error: 'Miqdor 0 dan katta bo\'lishi kerak');
      return false;
    }

    final db = MockDatabase();
    final productIndex = db.products.indexWhere((p) => p.id == state.productId);
    if (productIndex == -1) {
      state = state.copyWith(error: 'Mahsulot topilmadi');
      return false;
    }

    final product = db.products[productIndex];
    final totalQty = product.currentQuantity;
    final stockRepository = StockRepositoryImpl();
    final balance = await stockRepository.getBalance(state.productId!, state.warehouseId!);
    final warehouseQty = balance?.quantity ?? 0;

    if (qty > warehouseQty) {
      state = state.copyWith(
        error: 'Miqdor tanlangan ombordagi qoldiqdan oshib ketdi ($warehouseQty ${product.unit})',
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    final user = ref.read(authProvider).maybeWhen(data: (u) => u, orElse: () => null);

    final movement = StockMovementModel(
      id: const Uuid().v4(),
      productId: state.productId!,
      warehouseId: state.warehouseId!,
      movementType: MovementType.outbound,
      quantity: qty,
      beforeQuantity: warehouseQty,
      afterQuantity: warehouseQty - qty,
      reason: state.reason.isEmpty ? null : state.reason,
      note: state.note.trim().isEmpty ? null : state.note.trim(),
      createdBy: user?.id ?? 'unknown',
      createdAt: DateTime.now(),
      productName: product.name,
      warehouseName: db.warehouses
          .where((w) => w.id == state.warehouseId)
          .map((w) => w.name)
          .firstOrNull,
      createdByName: user?.name,
    );

    await stockRepository.createMovement(movement);
    await ref.read(productRepositoryProvider).updateQuantity(state.productId!, totalQty - qty);
    ref.invalidate(productListProvider);
    ref.invalidate(movementListProvider);

    state = state.copyWith(isSubmitting: false, success: true);
    return true;
  }

  void reset() => state = const StockOutFormState();
}
