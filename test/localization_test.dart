import 'package:flutter_test/flutter_test.dart';
import 'package:sales_system_warehouse_mobile/core/utils/enums.dart';
import 'package:sales_system_warehouse_mobile/shared/mock_data/mock_categories.dart';

void main() {
  test('Enum labels are correct', () {
    expect(UserRole.admin.labelRu, 'Администратор');
    expect(MovementType.outbound.labelRu, 'Расход');
    expect(MovementType.inbound.labelUz, 'Kirim');
  });

  test('Category data is correct', () {
    expect(mockCategories.first.nameRu, 'Деревянные изделия');
    expect(mockCategories.first.nameUz, "Yog'ochlar");
    expect(mockCategories.length, 12);
  });
}
