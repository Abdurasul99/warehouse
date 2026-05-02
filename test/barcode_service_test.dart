import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sales_system_warehouse_mobile/shared/mock_data/mock_products.dart';
import 'package:sales_system_warehouse_mobile/shared/services/barcode_service.dart';

void main() {
  group('normalizeBarcode', () {
    test('trims and removes whitespace', () {
      expect(
        BarcodeScannerService.normalizeBarcode(' 4600 0000\n00001 '),
        '4600000000001',
      );
    });
    test('returns null for empty / null', () {
      expect(BarcodeScannerService.normalizeBarcode(''), isNull);
      expect(BarcodeScannerService.normalizeBarcode(null), isNull);
      expect(BarcodeScannerService.normalizeBarcode('   '), isNull);
    });
  });

  group('findProductByBarcode', () {
    test('returns matching product (with surrounding whitespace)', () {
      final product = BarcodeScannerService.findProductByBarcode(
        mockProducts,
        ' 4600000000001 ',
      );
      expect(product?.id, 'prod_001');
    });

    test('returns null for unknown barcode', () {
      final product = BarcodeScannerService.findProductByBarcode(
        mockProducts,
        '0000000000000',
      );
      expect(product, isNull);
    });

    test('returns null for null/empty input', () {
      expect(
        BarcodeScannerService.findProductByBarcode(mockProducts, null),
        isNull,
      );
      expect(
        BarcodeScannerService.findProductByBarcode(mockProducts, ''),
        isNull,
      );
    });
  });

  group('generateEan13', () {
    test('produces 13-digit numeric strings', () {
      for (var i = 0; i < 100; i++) {
        final code = BarcodeScannerService.generateEan13(rng: Random(i));
        expect(code.length, 13);
        expect(RegExp(r'^\d{13}$').hasMatch(code), true);
      }
    });

    test('uses default prefix 200', () {
      final code = BarcodeScannerService.generateEan13(rng: Random(42));
      expect(code.startsWith('200'), true);
    });

    test('respects custom prefix', () {
      final code = BarcodeScannerService.generateEan13(
        prefix: '299',
        rng: Random(7),
      );
      expect(code.startsWith('299'), true);
      expect(code.length, 13);
    });

    test('checksum digit is valid EAN-13', () {
      final code = BarcodeScannerService.generateEan13(rng: Random(3));
      final first12 = code.substring(0, 12);
      final last = int.parse(code[12]);
      var sum = 0;
      for (var i = 0; i < first12.length; i++) {
        final d = int.parse(first12[i]);
        sum += i.isEven ? d : d * 3;
      }
      final expected = (10 - sum % 10) % 10;
      expect(last, expected);
    });
  });

  group('generateUniqueEan13', () {
    test('returns unique value when no collisions', () {
      final code = BarcodeScannerService.generateUniqueEan13(
        const [],
        rng: Random(1),
      );
      expect(code.length, 13);
      expect(code.startsWith('200'), true);
    });

    test('avoids collision with existing barcodes', () {
      final code = BarcodeScannerService.generateUniqueEan13(
        mockProducts,
        rng: Random(99),
      );
      final collision = BarcodeScannerService.findProductByBarcode(
        mockProducts,
        code,
      );
      expect(collision, isNull);
    });
  });
}
