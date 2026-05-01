import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/analytics_summary.dart';

class ReorderPreviewWidget extends ConsumerWidget {
  final List<ReorderItem> items;

  const ReorderPreviewWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppDim.paddingM),
        decoration: BoxDecoration(
          color: AppColors.statusOk.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppDim.radiusL),
          border: Border.all(
              color: AppColors.statusOk.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: AppColors.statusOk, size: 20),
            const SizedBox(width: AppDim.paddingS),
            Expanded(
              child: Text(
                l10n.analytics_reorder_empty,
                style: AppTextStyles.body2
                    .copyWith(color: AppColors.statusOk),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(AppDim.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDim.radiusL),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.analytics_reorder_title, style: AppTextStyles.heading3),
          const SizedBox(height: AppDim.paddingS),
          for (var i = 0; i < items.length; i++) ...[
            _ReorderRow(
              item: items[i],
              onTap: () => context.pushNamed(
                AppRoutes.productDetail,
                pathParameters: {'id': items[i].product.id},
              ),
            ),
            if (i != items.length - 1)
              const Divider(height: AppDim.paddingM),
          ],
        ],
      ),
    );
  }
}

class _ReorderRow extends StatelessWidget {
  final ReorderItem item;
  final VoidCallback onTap;

  const _ReorderRow({required this.item, required this.onTap});

  Color _barColor() => switch (item.level) {
        HealthLevel.red => AppColors.statusCritical,
        HealthLevel.yellow => AppColors.statusLow,
        HealthLevel.green => AppColors.statusOk,
      };

  @override
  Widget build(BuildContext context) {
    final p = item.product;
    final color = _barColor();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDim.radiusS),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: AppDim.paddingS),
                Text(
                  '${p.currentQuantity} / ${p.minQuantity} ${p.unit}',
                  style: AppTextStyles.caption.copyWith(color: color),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDim.radiusS),
              child: LinearProgressIndicator(
                value: item.ratio.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
