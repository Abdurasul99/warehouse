import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales_system_warehouse_mobile/features/products/presentation/providers/product_provider.dart';
import 'package:sales_system_warehouse_mobile/shared/mock_data/mock_database.dart';
import 'package:sales_system_warehouse_mobile/shared/models/product_model.dart';

ProductModel _seed({
  required String id,
  required String ownerId,
}) {
  final now = DateTime(2026, 5, 1);
  return ProductModel(
    id: id,
    name: 'P-$id',
    sku: 'SKU-$id',
    categoryId: 'cat_01',
    unit: 'dona',
    purchasePrice: 100,
    sellingPrice: 150,
    currentQuantity: 10,
    minQuantity: 2,
    ownerUserId: ownerId,
    createdAt: now,
    updatedAt: now,
  );
}

ProviderContainer _makeContainer(String? userId) {
  return ProviderContainer(
    overrides: [currentUserIdProvider.overrideWithValue(userId)],
  );
}

void main() {
  setUp(() {
    final db = MockDatabase();
    db.users = [];
    db.categories = [];
    db.products = [
      _seed(id: 'admin1', ownerId: 'usr_01'),
      _seed(id: 'admin2', ownerId: 'usr_01'),
      _seed(id: 'sales1', ownerId: 'usr_04'),
    ];
    db.warehouses = [];
    db.stockBalances = [];
    db.movements = [];
  });

  tearDownAll(() {
    MockDatabase().reset();
  });

  test('admin sees only their products', () async {
    final c = _makeContainer('usr_01');
    addTearDown(c.dispose);
    final list = await c.read(productListProvider.future);
    expect(list.map((p) => p.id), unorderedEquals(['admin1', 'admin2']));
  });

  test('sotuv1 sees only their products', () async {
    final c = _makeContainer('usr_04');
    addTearDown(c.dispose);
    final list = await c.read(productListProvider.future);
    expect(list.map((p) => p.id), ['sales1']);
  });

  test('new user with no owned products sees empty list', () async {
    final c = _makeContainer('usr_99');
    addTearDown(c.dispose);
    final list = await c.read(productListProvider.future);
    expect(list, isEmpty);
  });

  test('unauthenticated user sees empty list', () async {
    final c = _makeContainer(null);
    addTearDown(c.dispose);
    final list = await c.read(productListProvider.future);
    expect(list, isEmpty);
  });

  test('switching user invalidates and re-filters', () async {
    final c = _makeContainer('usr_01');
    addTearDown(c.dispose);
    final adminList = await c.read(productListProvider.future);
    expect(adminList.length, 2);

    // Container override is immutable; re-create to simulate user switch.
    final c2 = _makeContainer('usr_04');
    addTearDown(c2.dispose);
    final salesList = await c2.read(productListProvider.future);
    expect(salesList.length, 1);
    expect(salesList.first.id, 'sales1');
  });
}
