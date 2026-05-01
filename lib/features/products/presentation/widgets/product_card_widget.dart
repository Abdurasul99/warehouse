import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/status_badge_widget.dart';
import '../../../../shared/models/category_model.dart';
import '../../../../shared/models/product_model.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel product;
  final List<CategoryModel> categories;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.categories,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = categories.where((c) => c.id == product.categoryId).firstOrNull;
    final locale = Localizations.localeOf(context).languageCode;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDim.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppDim.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _ProductThumbnail(product: product),
                  const SizedBox(width: AppDim.paddingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: AppTextStyles.heading3.copyWith(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (category != null)
                          Text(
                            category.localizedName(locale),
                            style: AppTextStyles.body2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  StatusBadge(status: product.stockStatus),
                ],
              ),
              const SizedBox(height: AppDim.paddingM),
              const Divider(height: 1),
              const SizedBox(height: AppDim.paddingS),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoItem(
                    label: context.l10n.products_qty_label,
                    value: '${product.currentQuantity} ${product.unit}',
                    valueColor: product.currentQuantity <= product.minQuantity
                        ? AppColors.statusCritical
                        : AppColors.textPrimary,
                  ),
                  _InfoItem(
                    label: 'SKU',
                    value: product.sku,
                    align: TextAlign.center,
                  ),
                  _InfoItem(
                    label: context.l10n.products_selling_price_label,
                    value: product.sellingPrice.toStringAsFixed(0),
                    align: TextAlign.right,
                    valueColor: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final TextAlign align;
  final Color? valueColor;

  const _InfoItem({
    required this.label,
    required this.value,
    this.align = TextAlign.left,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align == TextAlign.right
          ? CrossAxisAlignment.end
          : align == TextAlign.center
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        Text(
          value,
          style: AppTextStyles.body2.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
          textAlign: align,
        ),
      ],
    );
  }
}

class _ProductThumbnail extends StatelessWidget {
  final ProductModel product;
  const _ProductThumbnail({required this.product});

  IconData _iconForCategory(String categoryId) {
    switch (categoryId) {
      case 'cat_01': return Icons.carpenter;
      case 'cat_02': return Icons.hardware;
      case 'cat_03': return Icons.coffee_outlined;
      case 'cat_04': return Icons.checkroom;
      case 'cat_05': return Icons.checkroom_outlined;
      case 'cat_06': return Icons.content_cut;
      case 'cat_07': return Icons.inbox_outlined;
      case 'cat_08': return Icons.face_retouching_natural;
      case 'cat_09': return Icons.attractions;
      case 'cat_10': return Icons.shopping_bag_outlined;
      case 'cat_11': return Icons.ac_unit;
      case 'cat_12': return Icons.image_outlined;
      default: return Icons.inventory_2_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoPath = product.imagePlaceholder;
    final hasPhoto = photoPath != null &&
        photoPath.isNotEmpty &&
        File(photoPath).existsSync();
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDim.radiusM),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasPhoto
          ? Image.file(File(photoPath), fit: BoxFit.cover)
          : Icon(
              _iconForCategory(product.categoryId),
              color: AppColors.primary,
              size: AppDim.iconSizeM,
            ),
    );
  }
}
