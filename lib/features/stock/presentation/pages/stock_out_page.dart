import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/quantity_input_widget.dart';
import '../../../../shared/mock_data/mock_database.dart';
import '../providers/stock_out_provider.dart';
import '../widgets/product_selector_widget.dart';

class StockOutPage extends ConsumerStatefulWidget {
  const StockOutPage({super.key});

  @override
  ConsumerState<StockOutPage> createState() => _StockOutPageState();
}

class _StockOutPageState extends ConsumerState<StockOutPage> {
  final _qtyController = TextEditingController(text: '1');
  final _noteController = TextEditingController();

  static const _reasons = [
    ('Sale', 'Sotuv'),
    ('Damaged', 'Yaroqsiz'),
    ('ReturnToSupplier', 'Etkazib beruvchiga qaytarish'),
    ('InternalUse', "Ichki foydalanish"),
    ('Correction', "To'g'irlash"),
  ];

  @override
  void dispose() {
    _qtyController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    ref.read(stockOutProvider.notifier).setQuantity(_qtyController.text);
    ref.read(stockOutProvider.notifier).setNote(_noteController.text);
    final success = await ref.read(stockOutProvider.notifier).submit();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.l10n.stock_success_out),
        backgroundColor: AppColors.statusOk,
      ));
      ref.read(stockOutProvider.notifier).reset();
      _qtyController.text = '1';
      _noteController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(stockOutProvider);
    final warehouses = MockDatabase().warehouses;
    final selectedProduct = formState.productId != null
        ? MockDatabase()
            .products
            .where((p) => p.id == formState.productId)
            .firstOrNull
        : null;
    final selectedBalance =
        selectedProduct != null && formState.warehouseId != null
            ? MockDatabase()
                .stockBalances
                .where(
                  (b) =>
                      b.productId == selectedProduct.id &&
                      b.warehouseId == formState.warehouseId,
                )
                .firstOrNull
            : null;
    final availableQty = selectedBalance?.quantity ?? 0;
    final displayedQty = formState.warehouseId == null
        ? selectedProduct?.currentQuantity ?? 0
        : availableQty;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.stock_out_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.dashboard),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDim.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionHeader(
              icon: Icons.arrow_circle_up_outlined,
              color: AppColors.movementOut,
              title: context.l10n.stock_out_title,
            ),
            const SizedBox(height: AppDim.paddingL),
            if (formState.error != null) _ErrorCard(formState.error!),
            if (selectedProduct != null) ...[
              Container(
                padding: const EdgeInsets.all(AppDim.paddingM),
                margin: const EdgeInsets.only(bottom: AppDim.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppDim.radiusM),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined,
                        color: AppColors.primary),
                    const SizedBox(width: AppDim.paddingS),
                    Expanded(
                      child: Text(
                        '${context.l10n.products_qty_label}: $displayedQty ${selectedProduct.unit}',
                        style: AppTextStyles.body1
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            ProductSelectorWidget(
              selectedProductId: formState.productId,
              onChanged: (id) =>
                  ref.read(stockOutProvider.notifier).setProduct(id),
              label: context.l10n.stock_product_label,
            ),
            const SizedBox(height: AppDim.paddingM),
            Text(context.l10n.stock_warehouse_label,
                style: AppTextStyles.body1),
            const SizedBox(height: AppDim.paddingXS),
            DropdownButtonFormField<String>(
              initialValue: formState.warehouseId,
              hint: Text(context.l10n.stock_warehouse_label),
              decoration: const InputDecoration(),
              items: warehouses
                  .map(
                      (w) => DropdownMenuItem(value: w.id, child: Text(w.name)))
                  .toList(),
              onChanged: (v) =>
                  ref.read(stockOutProvider.notifier).setWarehouse(v),
            ),
            const SizedBox(height: AppDim.paddingM),
            QuantityInputWidget(
              controller: _qtyController,
              label: context.l10n.stock_qty_label,
              max: selectedProduct == null || formState.warehouseId == null
                  ? null
                  : availableQty,
              onChanged: (v) =>
                  ref.read(stockOutProvider.notifier).setQuantity(v),
            ),
            const SizedBox(height: AppDim.paddingM),
            Text(context.l10n.stock_reason_label, style: AppTextStyles.body1),
            const SizedBox(height: AppDim.paddingXS),
            DropdownButtonFormField<String>(
              initialValue: formState.reason.isEmpty ? null : formState.reason,
              hint: Text(context.l10n.stock_reason_label),
              decoration: const InputDecoration(),
              items: _reasons
                  .map((r) => DropdownMenuItem(value: r.$1, child: Text(r.$2)))
                  .toList(),
              onChanged: (v) =>
                  ref.read(stockOutProvider.notifier).setReason(v ?? ''),
            ),
            const SizedBox(height: AppDim.paddingM),
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: context.l10n.stock_note_label,
                hintText: context.l10n.stock_note_hint,
              ),
            ),
            const SizedBox(height: AppDim.paddingXL),
            ElevatedButton.icon(
              onPressed: formState.isSubmitting ? null : _submit,
              icon: formState.isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.check),
              label: Text(context.l10n.btn_save),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.movementOut),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  const _SectionHeader(
      {required this.icon, required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDim.paddingS),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppDim.radiusM),
          ),
          child: Icon(icon, color: color, size: AppDim.iconSizeL),
        ),
        const SizedBox(width: AppDim.paddingM),
        Text(title, style: AppTextStyles.heading2),
      ],
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDim.paddingM),
      padding: const EdgeInsets.all(AppDim.paddingM),
      decoration: BoxDecoration(
        color: AppColors.statusCritical.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDim.radiusM),
        border:
            Border.all(color: AppColors.statusCritical.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline,
              color: AppColors.statusCritical, size: 18),
          const SizedBox(width: AppDim.paddingS),
          Expanded(
              child: Text(message,
                  style: AppTextStyles.body2
                      .copyWith(color: AppColors.statusCritical))),
        ],
      ),
    );
  }
}
