import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/status_badge_widget.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/services/barcode_service.dart';
import '../../../products/presentation/providers/product_provider.dart';

class ProductSelectorWidget extends ConsumerStatefulWidget {
  final String? selectedProductId;
  final ValueChanged<String?> onChanged;
  final String label;

  const ProductSelectorWidget({
    super.key,
    required this.selectedProductId,
    required this.onChanged,
    required this.label,
  });

  @override
  ConsumerState<ProductSelectorWidget> createState() => _ProductSelectorWidgetState();
}

class _ProductSelectorWidgetState extends ConsumerState<ProductSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListProvider);

    final selectedProduct = productsAsync.maybeWhen(
      data: (list) => list.where((p) => p.id == widget.selectedProductId).firstOrNull,
      orElse: () => null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.body1),
        const SizedBox(height: AppDim.paddingXS),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDim.paddingM),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDim.radiusM),
            border: Border.all(
              color: widget.selectedProductId != null
                  ? AppColors.primary
                  : AppColors.border,
              width: widget.selectedProductId != null ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _showPicker(context, productsAsync),
                  child: selectedProduct != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(selectedProduct.name, style: AppTextStyles.body1),
                            Text(
                              '${selectedProduct.currentQuantity} ${selectedProduct.unit} mavjud',
                              style: AppTextStyles.body2,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const Icon(Icons.search, color: AppColors.textSecondary),
                            const SizedBox(width: AppDim.paddingS),
                            Text(
                              'Mahsulot tanlang',
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.textDisabled,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(width: AppDim.paddingS),
              IconButton(
                tooltip: 'Barkod skanerlash',
                icon: const Icon(Icons.qr_code_scanner),
                color: AppColors.primary,
                onPressed: () => _scanAndSelectProduct(context, productsAsync),
              ),
              if (selectedProduct != null) ...[
                const SizedBox(width: AppDim.paddingS),
                StatusBadge(status: selectedProduct.stockStatus),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _scanAndSelectProduct(
    BuildContext context,
    AsyncValue<List<ProductModel>> productsAsync,
  ) async {
    final products = productsAsync.maybeWhen(
      data: (list) => list,
      orElse: () => <ProductModel>[],
    );

    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mahsulotlar hali yuklanmagan')),
      );
      return;
    }

    final code = await BarcodeScannerService().scanBarcode(context);
    if (!context.mounted || code == null) return;

    final product = BarcodeScannerService.findProductByBarcode(products, code);
    if (product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Barkod bo\'yicha mahsulot topilmadi: $code')),
      );
      return;
    }

    widget.onChanged(product.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} tanlandi')),
    );
  }

  void _showPicker(BuildContext context, AsyncValue<List<ProductModel>> productsAsync) {
    final products = productsAsync.maybeWhen(data: (l) => l, orElse: () => <ProductModel>[]);
    final searchController = TextEditingController();
    var filtered = products;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDim.radiusXL)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              const SizedBox(height: AppDim.paddingS),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppDim.paddingM),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Mahsulot qidirish...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (q) => setModalState(() {
                    final query = q.toLowerCase();
                    filtered = query.isEmpty
                        ? products
                        : products
                            .where(
                              (p) =>
                                  p.name.toLowerCase().contains(query) ||
                                  p.sku.toLowerCase().contains(query) ||
                                  (p.barcode?.contains(q) ?? false),
                            )
                            .toList();
                  }),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final p = filtered[i];
                    return ListTile(
                      title: Text(p.name, style: AppTextStyles.body1),
                      subtitle: Text('SKU: ${p.sku} - ${p.currentQuantity} ${p.unit}'),
                      trailing: StatusBadge(status: p.stockStatus),
                      selected: p.id == widget.selectedProductId,
                      selectedColor: AppColors.primary,
                      onTap: () {
                        widget.onChanged(p.id);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
