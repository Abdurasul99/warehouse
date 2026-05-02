import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_system_warehouse_mobile/features/products/presentation/providers/product_form_provider.dart';
import 'package:sales_system_warehouse_mobile/features/products/presentation/providers/product_provider.dart';
import 'package:sales_system_warehouse_mobile/features/stock/presentation/providers/stock_in_provider.dart';
import 'package:sales_system_warehouse_mobile/features/stock/presentation/providers/stock_out_provider.dart';
import 'package:sales_system_warehouse_mobile/shared/mock_data/mock_database.dart';

void main() {
  late MockDatabase db;

  ProviderContainer createContainer({String? userId = 'usr_01'}) {
    final container = ProviderContainer(
      overrides: [currentUserIdProvider.overrideWithValue(userId)],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = MockDatabase()..reset();
  });

  test('stock out validates quantity against the selected warehouse balance', () async {
    final container = createContainer();
    final notifier = container.read(stockOutProvider.notifier);
    final initialMovementCount = db.movements.length;

    notifier
      ..setProduct('prod_001')
      ..setWarehouse('wh_02')
      ..setQuantity('46');

    final success = await notifier.submit();

    expect(success, isFalse);
    expect(container.read(stockOutProvider).error, contains('45'));
    expect(db.products.firstWhere((p) => p.id == 'prod_001').currentQuantity, 145);
    expect(
      db.stockBalances
          .firstWhere((b) => b.productId == 'prod_001' && b.warehouseId == 'wh_02')
          .quantity,
      45,
    );
    expect(db.movements.length, initialMovementCount);
  });

  test('stock in updates product total and selected warehouse balance', () async {
    final container = createContainer();
    final notifier = container.read(stockInProvider.notifier);

    notifier
      ..setProduct('prod_001')
      ..setWarehouse('wh_02')
      ..setQuantity('5');

    final success = await notifier.submit();

    expect(success, isTrue);
    expect(db.products.firstWhere((p) => p.id == 'prod_001').currentQuantity, 150);
    expect(
      db.stockBalances
          .firstWhere((b) => b.productId == 'prod_001' && b.warehouseId == 'wh_02')
          .quantity,
      50,
    );
    expect(db.movements.first.beforeQuantity, 45);
    expect(db.movements.first.afterQuantity, 50);
  });

  test('editing a product preserves createdAt and updates updatedAt', () async {
    final container = createContainer();
    await container.read(productListProvider.future);

    final original = db.products.firstWhere((p) => p.id == 'prod_001');
    final notifier = container.read(productFormProvider(original.id).notifier);

    notifier.update((state) => state.copyWith(name: 'Updated product name'));
    final success = await notifier.submit();

    final updated = db.products.firstWhere((p) => p.id == original.id);
    expect(success, isTrue);
    expect(updated.name, 'Updated product name');
    expect(updated.createdAt, original.createdAt);
    expect(updated.updatedAt.isAfter(original.updatedAt), isTrue);
  });
}
