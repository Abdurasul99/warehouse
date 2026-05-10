import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:barcode_widget/barcode_widget.dart';

import '../models/product_model.dart';
import '../../core/theme/app_colors.dart';

class BarcodeLabelService {
  static final ScreenshotController _controller = ScreenshotController();

  static Future<void> shareLabel(BuildContext context, ProductModel product) async {
    if (product.barcode == null || product.barcode!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mahsulotda barkod yo\'q')),
      );
      return;
    }

    try {
      final Uint8List? imageBytes = await _controller.captureFromLongWidget(
        _BarcodeLabelWidget(product: product),
        pixelRatio: 3.0,
        context: context,
      );

      if (imageBytes == null) return;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/barcode_${product.sku}.png');
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: '${product.name} — ${product.barcode}',
        subject: 'Barkod: ${product.name}',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xatolik: $e')),
        );
      }
    }
  }
}

class _BarcodeLabelWidget extends StatelessWidget {
  final ProductModel product;
  const _BarcodeLabelWidget({required this.product});

  @override
  Widget build(BuildContext context) {
    final barcode = product.barcode ?? '';
    final isEan13 = barcode.length == 13 && int.tryParse(barcode) != null;

    return Material(
      color: Colors.white,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black26, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (product.sellingPrice > 0)
              Text(
                "${product.sellingPrice.toStringAsFixed(0)} so'm",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            const SizedBox(height: 10),
            if (isEan13)
              BarcodeWidget(
                barcode: Barcode.ean13(),
                data: barcode,
                width: 240,
                height: 80,
                style: const TextStyle(fontSize: 12, color: Colors.black),
                color: Colors.black,
                backgroundColor: Colors.white,
              )
            else
              BarcodeWidget(
                barcode: Barcode.code128(),
                data: barcode,
                width: 240,
                height: 80,
                style: const TextStyle(fontSize: 12, color: Colors.black),
                color: Colors.black,
                backgroundColor: Colors.white,
              ),
            const SizedBox(height: 4),
            Text(
              'SKU: ${product.sku}',
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
