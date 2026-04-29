import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/enums.dart';
import '../../../../shared/models/stock_movement_model.dart';
import '../../data/repositories/movement_repository_impl.dart';
import '../../domain/repositories/movement_repository.dart';

final movementRepositoryProvider = Provider<MovementRepository>(
  (_) => MovementRepositoryImpl(),
);

final movementListProvider =
    AsyncNotifierProvider<MovementListNotifier, List<StockMovementModel>>(
  MovementListNotifier.new,
);

class MovementListNotifier extends AsyncNotifier<List<StockMovementModel>> {
  @override
  Future<List<StockMovementModel>> build() async {
    return ref.read(movementRepositoryProvider).getAll();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.read(movementRepositoryProvider).getAll());
  }
}

class MovementFilter {
  final MovementType? type;
  final String? productId;
  final DateTime? from;
  final DateTime? to;

  const MovementFilter({this.type, this.productId, this.from, this.to});

  MovementFilter copyWith({
    MovementType? type,
    String? productId,
    bool clearType = false,
    bool clearProduct = false,
  }) =>
      MovementFilter(
        type: clearType ? null : (type ?? this.type),
        productId: clearProduct ? null : (productId ?? this.productId),
        from: from,
        to: to,
      );
}

final movementFilterProvider =
    NotifierProvider<MovementFilterNotifier, MovementFilter>(
  MovementFilterNotifier.new,
);

class MovementFilterNotifier extends Notifier<MovementFilter> {
  @override
  MovementFilter build() => const MovementFilter();

  void setType(MovementType? t) {
    state = t == null
        ? state.copyWith(clearType: true)
        : state.copyWith(type: t);
  }

  void clear() => state = const MovementFilter();
}

final filteredMovementsProvider =
    Provider<AsyncValue<List<StockMovementModel>>>((ref) {
  final listAsync = ref.watch(movementListProvider);
  final filter = ref.watch(movementFilterProvider);

  return listAsync.whenData((movements) {
    var result = movements;
    if (filter.type != null) {
      result = result.where((m) => m.movementType == filter.type).toList();
    }
    if (filter.productId != null) {
      result = result.where((m) => m.productId == filter.productId).toList();
    }
    return result;
  });
});
