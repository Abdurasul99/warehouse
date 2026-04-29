import 'package:flutter_test/flutter_test.dart';
import 'package:sales_system_warehouse_mobile/shared/mock_data/mock_products.dart';
import 'package:sales_system_warehouse_mobile/shared/services/barcode_service.dart';

void main() {
  test('normalizeBarcode trims and removes whitespace', () {
    expect(BarcodeScannerService.normalizeBarcode(' 4600 0000\n00001 '), '4600000000001');
    expect(BarcodeScannerService.normalizeBarcode(''), isNull);
    expect(BarcodeScannerService.normalizeBarcode(null), isNull);
  });

  test('findProductByBarcode returns matching product', () {
    final product = BarcodeScannerService.findProductByBarcode(
      mockProducts,
      ' 4600000000001 ',
    );

    expect(product?.id, 'prod_001');
  });

  test('findProductByBarcode returns null for unknown barcode', () {
    final product = BarcodeScannerService.findProductByBarcode(
      mockProducts,
      '0000000000000',
    );

    expect(product, isNull);
  });
}
