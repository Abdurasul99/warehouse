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
import '../providers/stock_in_provider.dart';
import '../widgets/product_selector_widget.dart';

class StockInPage extends ConsumerStatefulWidget {
  const StockInPage({super.key});

  @override
  ConsumerState<StockInPage> createState() => _StockInPageState();
}

class _StockInPageState extends ConsumerState<StockInPage> {
  final _qtyController = TextEditingController(text: '1');
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _qtyController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    ref.read(stockInProvider.notifier).setQuantity(_qtyController.text);
    ref.read(stockInProvider.notifier).setNote(_noteController.text);
    final success = await ref.read(stockInProvider.notifier).submit();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.l10n.stock_success_in),
        backgroundColor: AppColors.statusOk,
      ));
      ref.read(stockInProvider.notifier).reset();
      _qtyController.text = '1';
      _noteController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(stockInProvider);
    final warehouses = MockDatabase().warehouses;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.stock_in_title),
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
              icon: Icons.arrow_circle_down_outlined,
              color: AppColors.movementIn,
              title: context.l10n.stock_in_title,
            ),
            const SizedBox(height: AppDim.paddingL),
            if (formState.error != null) _ErrorCard(formState.error!),
            ProductSelectorWidget(
              selectedProductId: formState.productId,
              onChanged: (id) =>
                  ref.read(stockInProvider.notifier).setProduct(id),
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
                  ref.read(stockInProvider.notifier).setWarehouse(v),
            ),
            const SizedBox(height: AppDim.paddingM),
            QuantityInputWidget(
              controller: _qtyController,
              label: context.l10n.stock_qty_label,
              onChanged: (v) =>
                  ref.read(stockInProvider.notifier).setQuantity(v),
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
                  backgroundColor: AppColors.movementIn),
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
