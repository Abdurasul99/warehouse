import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../models/product_model.dart';

class BarcodeScannerService {
  static const List<BarcodeFormat> supportedFormats = [
    BarcodeFormat.ean13,
    BarcodeFormat.ean8,
    BarcodeFormat.code128,
    BarcodeFormat.code39,
    BarcodeFormat.code93,
    BarcodeFormat.codabar,
    BarcodeFormat.upcA,
    BarcodeFormat.upcE,
    BarcodeFormat.qrCode,
  ];

  Future<String?> scanBarcode(BuildContext context) async {
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const BarcodeScannerPage()),
    );
    return normalizeBarcode(code);
  }

  static String? normalizeBarcode(String? value) {
    final normalized = value?.replaceAll(RegExp(r'\s+'), '').trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }

  static ProductModel? findProductByBarcode(
    Iterable<ProductModel> products,
    String? barcode,
  ) {
    final normalized = normalizeBarcode(barcode);
    if (normalized == null) return null;

    return products
        .where((product) => normalizeBarcode(product.barcode) == normalized)
        .firstOrNull;
  }

  static String generateEan13({String prefix = '200', Random? rng}) {
    final random = rng ?? Random();
    final buffer = StringBuffer(prefix);
    final remaining = 12 - prefix.length;
    for (var i = 0; i < remaining; i++) {
      buffer.write(random.nextInt(10));
    }
    final first12 = buffer.toString();
    return first12 + _ean13Checksum(first12);
  }

  static String _ean13Checksum(String first12) {
    var sum = 0;
    for (var i = 0; i < first12.length; i++) {
      final digit = int.parse(first12[i]);
      sum += i.isEven ? digit : digit * 3;
    }
    final check = (10 - sum % 10) % 10;
    return check.toString();
  }

  static String generateUniqueEan13(
    Iterable<ProductModel> existing, {
    int maxAttempts = 10,
    Random? rng,
  }) {
    String candidate = generateEan13(rng: rng);
    for (var i = 0; i < maxAttempts; i++) {
      if (findProductByBarcode(existing, candidate) == null) {
        return candidate;
      }
      candidate = generateEan13(rng: rng);
    }
    return candidate;
  }
}

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  late final MobileScannerController _controller = MobileScannerController(
    formats: BarcodeScannerService.supportedFormats,
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (_handled) return;

    final rawValue = capture.barcodes
        .map((barcode) => barcode.rawValue ?? barcode.displayValue)
        .whereType<String>()
        .map(BarcodeScannerService.normalizeBarcode)
        .whereType<String>()
        .firstOrNull;

    if (rawValue == null) return;

    _handled = true;
    Navigator.of(context).pop(rawValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Barkodni skanerlash'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Chiroq',
            icon: const Icon(Icons.flashlight_on_outlined),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            tooltip: 'Kamera',
            icon: const Icon(Icons.cameraswitch_outlined),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _handleBarcode,
            errorBuilder: (context, error, _) => _ScannerMessage(
              icon: Icons.no_photography_outlined,
              title: 'Kamera ochilmadi',
              message: 'Kamera ruxsatini tekshiring va qayta urinib ko\'ring.',
              action: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Yopish'),
              ),
            ),
          ),
          const _ScannerOverlay(),
          const Align(
            alignment: Alignment.bottomCenter,
            child: _ScannerHint(),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 260,
          height: 160,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryLight, width: 3),
            borderRadius: BorderRadius.circular(AppDim.radiusL),
          ),
        ),
      ),
    );
  }
}

class _ScannerHint extends StatelessWidget {
  const _ScannerHint();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDim.paddingM),
        color: Colors.black.withValues(alpha: 0.72),
        child: Text(
          'Barkodni ramka ichiga joylashtiring',
          textAlign: TextAlign.center,
          style: AppTextStyles.body1.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class _ScannerMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget action;

  const _ScannerMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDim.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 48),
              const SizedBox(height: AppDim.paddingM),
              Text(
                title,
                style: AppTextStyles.heading2.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDim.paddingS),
              Text(
                message,
                style: AppTextStyles.body2.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDim.paddingM),
              action,
            ],
          ),
        ),
      ),
    );
  }
}
