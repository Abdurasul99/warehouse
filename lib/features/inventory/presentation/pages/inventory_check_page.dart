import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../shared/mock_data/mock_database.dart';
import '../../../../shared/models/product_model.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../providers/inventory_provider.dart';

class InventoryCheckPage extends ConsumerStatefulWidget {
  const InventoryCheckPage({super.key});

  @override
  ConsumerState<InventoryCheckPage> createState() => _InventoryCheckPageState();
}

class _InventoryCheckPageState extends ConsumerState<InventoryCheckPage> {
  String _selectedWarehouseId = MockDatabase().warehouses.first.id;

  Future<void> _submit() async {
    final ok =
        await ref.read(inventoryProvider.notifier).submit(_selectedWarehouseId);
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.l10n.inventory_success_message),
        backgroundColor: AppColors.statusOk,
      ));
      ref.read(inventoryProvider.notifier).reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final invState = ref.watch(inventoryProvider);
    final productsAsync = ref.watch(productListProvider);
    final warehouses = MockDatabase().warehouses;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.inventory_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.dashboard),
        ),
      ),
      body: productsAsync.when(
        data: (products) => Column(
          children: [
            _WarehouseBar(
              warehouses: warehouses,
              selected: _selectedWarehouseId,
              onChanged: (v) => setState(() => _selectedWarehouseId = v),
            ),
            if (invState.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDim.paddingM, vertical: AppDim.paddingXS),
                child: Text(invState.error!,
                    style: AppTextStyles.body2
                        .copyWith(color: AppColors.statusCritical)),
              ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                    AppDim.paddingM, AppDim.paddingS, AppDim.paddingM, 100),
                itemCount: products.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final product = products[i];
                  final balance = MockDatabase()
                      .stockBalances
                      .where(
                        (b) =>
                            b.productId == product.id &&
                            b.warehouseId == _selectedWarehouseId,
                      )
                      .firstOrNull;
                  return InventoryRowWidget(
                    product: product,
                    expectedQuantity: balance?.quantity ?? 0,
                    actualCount:
                        ref.watch(inventoryProvider).actualCounts[product.id],
                    onChanged: (v) => ref
                        .read(inventoryProvider.notifier)
                        .setActualCount(product.id, v),
                  );
                },
              ),
            ),
          ],
        ),
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDim.paddingM),
          child: ElevatedButton(
            onPressed: invState.isSubmitting ? null : _submit,
            child: invState.isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : Text(context.l10n.inventory_btn_save_all),
          ),
        ),
      ),
    );
  }
}

class _WarehouseBar extends StatelessWidget {
  final List<dynamic> warehouses;
  final String selected;
  final ValueChanged<String> onChanged;
  const _WarehouseBar(
      {required this.warehouses,
      required this.selected,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
          horizontal: AppDim.paddingM, vertical: AppDim.paddingS),
      child: DropdownButtonFormField<String>(
        initialValue: selected,
        decoration: const InputDecoration(
          labelText: AppStrings.appName,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        items: warehouses
            .map((w) =>
                DropdownMenuItem<String>(value: w.id, child: Text(w.name)))
            .toList(),
        onChanged: (v) => v != null ? onChanged(v) : null,
      ),
    );
  }
}

class InventoryRowWidget extends StatefulWidget {
  final ProductModel product;
  final int expectedQuantity;
  final int? actualCount;
  final ValueChanged<int?> onChanged;

  const InventoryRowWidget({
    super.key,
    required this.product,
    required this.expectedQuantity,
    required this.actualCount,
    required this.onChanged,
  });

  @override
  State<InventoryRowWidget> createState() => _InventoryRowWidgetState();
}

class _InventoryRowWidgetState extends State<InventoryRowWidget> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.actualCount?.toString() ?? '');

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diff = widget.actualCount != null
        ? widget.actualCount! - widget.expectedQuantity
        : 0;
    final hasDiff = widget.actualCount != null &&
        widget.actualCount != widget.expectedQuantity;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDim.paddingS),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.product.name,
                    style: AppTextStyles.body1
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(
                    '${context.l10n.inventory_expected_label}: '
                    '${widget.expectedQuantity} ${widget.product.unit}',
                    style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(width: AppDim.paddingS),
          SizedBox(
            width: 80,
            child: TextField(
              controller: _ctrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '0',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDim.radiusM),
                  borderSide: BorderSide(
                    color: hasDiff ? AppColors.statusLow : AppColors.border,
                    width: hasDiff ? 2 : 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDim.radiusM),
                  borderSide: BorderSide(
                    color: hasDiff ? AppColors.statusLow : AppColors.border,
                    width: hasDiff ? 2 : 1,
                  ),
                ),
              ),
              onChanged: (v) => widget.onChanged(int.tryParse(v)),
            ),
          ),
          const SizedBox(width: AppDim.paddingS),
          SizedBox(
            width: 52,
            child: hasDiff
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: (diff > 0
                              ? AppColors.statusOk
                              : AppColors.statusCritical)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppDim.radiusS),
                    ),
                    child: Text(
                      '${diff > 0 ? '+' : ''}$diff',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body2.copyWith(
                        color: diff > 0
                            ? AppColors.statusOk
                            : AppColors.statusCritical,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
