import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/status_badge_widget.dart';
import '../providers/product_provider.dart';

class ProductDetailPage extends ConsumerWidget {
  final String id;
  const ProductDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(id));
    final categoriesAsync = ref.watch(categoryListProvider);
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.products_detail_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          productAsync.maybeWhen(
            data: (product) => product != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => context.goNamed(
                          AppRoutes.productEdit,
                          pathParameters: {'id': id},
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmDelete(context, ref),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return const Center(child: Text('Mahsulot topilmadi'));
          }
          final category = categoriesAsync.maybeWhen(
            data: (cats) => cats.where((c) => c.id == product.categoryId).firstOrNull,
            orElse: () => null,
          );
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDim.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderCard(product: product, category: category?.localizedName(locale)),
                const SizedBox(height: AppDim.paddingM),
                _StockCard(product: product, l10n: context.l10n),
                const SizedBox(height: AppDim.paddingM),
                _PriceCard(product: product, l10n: context.l10n),
                const SizedBox(height: AppDim.paddingM),
                _InfoCard(product: product, l10n: context.l10n),
                const SizedBox(height: AppDim.paddingL),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.goNamed(AppRoutes.stockIn),
                        icon: const Icon(Icons.arrow_circle_down_outlined),
                        label: Text(context.l10n.dashboard_card_stock_in),
                      ),
                    ),
                    const SizedBox(width: AppDim.paddingM),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.goNamed(AppRoutes.stockOut),
                        icon: const Icon(Icons.arrow_circle_up_outlined),
                        label: Text(context.l10n.dashboard_card_stock_out),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.movementOut,
                          side: const BorderSide(color: AppColors.movementOut),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Mahsulotni o\'chirish',
      message: 'Bu mahsulotni o\'chirishni tasdiqlaysizmi?',
      confirmLabel: 'O\'chirish',
      isDestructive: true,
    );
    if (confirmed && context.mounted) {
      await ref.read(productListProvider.notifier).delete(id);
      if (context.mounted) context.goNamed(AppRoutes.productList);
    }
  }
}

class _HeaderCard extends StatelessWidget {
  final dynamic product;
  final String? category;
  const _HeaderCard({required this.product, this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDim.paddingM),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDim.radiusL),
              ),
              child: const Icon(Icons.inventory_2_outlined,
                  color: AppColors.primary, size: AppDim.iconSizeL),
            ),
            const SizedBox(width: AppDim.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: AppTextStyles.heading2),
                  if (category != null)
                    Text(category!, style: AppTextStyles.body2),
                  const SizedBox(height: AppDim.paddingXS),
                  StatusBadge(status: product.stockStatus),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockCard extends StatelessWidget {
  final dynamic product;
  final dynamic l10n;
  const _StockCard({required this.product, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDim.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('QOLDIQ', style: AppTextStyles.label.copyWith(color: AppColors.primary)),
            const SizedBox(height: AppDim.paddingS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _DetailItem(label: l10n.products_qty_label,
                    value: '${product.currentQuantity} ${product.unit}'),
                _DetailItem(label: l10n.products_min_qty_label,
                    value: '${product.minQuantity} ${product.unit}'),
                _DetailItem(label: 'SKU', value: product.sku),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  final dynamic product;
  final dynamic l10n;
  const _PriceCard({required this.product, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDim.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NARXLAR', style: AppTextStyles.label.copyWith(color: AppColors.primary)),
            const SizedBox(height: AppDim.paddingS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _DetailItem(
                    label: l10n.products_purchase_price_label,
                    value: "${product.purchasePrice.toStringAsFixed(0)} so'm"),
                _DetailItem(
                    label: l10n.products_selling_price_label,
                    value: "${product.sellingPrice.toStringAsFixed(0)} so'm",
                    valueColor: AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final dynamic product;
  final dynamic l10n;
  const _InfoCard({required this.product, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDim.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("MA'LUMOT", style: AppTextStyles.label.copyWith(color: AppColors.primary)),
            const SizedBox(height: AppDim.paddingS),
            if (product.barcode != null)
              _DetailRow(label: l10n.products_barcode_label, value: product.barcode!),
            if (product.description != null)
              _DetailRow(label: l10n.products_description_label, value: product.description!),
            _DetailRow(
                label: "Yaratilgan",
                value: DateFormatter.formatDate(product.createdAt)),
            _DetailRow(
                label: "Yangilangan",
                value: DateFormatter.formatDate(product.updatedAt)),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _DetailItem({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.caption),
        Text(value,
            style: AppTextStyles.body1
                .copyWith(fontWeight: FontWeight.w600, color: valueColor)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppTextStyles.body2),
          ),
          Expanded(
            child: Text(value,
                style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
