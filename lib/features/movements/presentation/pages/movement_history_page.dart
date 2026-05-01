import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../shared/models/stock_movement_model.dart';
import '../providers/movement_provider.dart';

class MovementHistoryPage extends ConsumerWidget {
  const MovementHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredMovementsProvider);
    final filter = ref.watch(movementFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.movements_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.goNamed(AppRoutes.dashboard),
        ),
        actions: [
          if (filter.type != null)
            TextButton(
              onPressed: () => ref.read(movementFilterProvider.notifier).clear(),
              child: Text(context.l10n.btn_cancel,
                  style: const TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Column(
        children: [
          _TypeFilterBar(filter: filter, ref: ref),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(movementListProvider.notifier).refresh(),
              child: filteredAsync.when(
                data: (movements) => movements.isEmpty
                    ? EmptyStateWidget(
                        message: context.l10n.movements_empty,
                        icon: Icons.history_outlined,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDim.paddingM, vertical: AppDim.paddingS),
                        itemCount: movements.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppDim.paddingXS),
                        itemBuilder: (_, i) => MovementTile(movement: movements[i]),
                      ),
                loading: () => const LoadingWidget(),
                error: (e, _) => Center(child: Text(e.toString())),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeFilterBar extends StatelessWidget {
  final MovementFilter filter;
  final WidgetRef ref;
  const _TypeFilterBar({required this.filter, required this.ref});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return Container(
      color: Colors.white,
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppDim.paddingM, vertical: AppDim.paddingXS),
        children: [
          _Chip(
            label: locale == 'ru' ? 'Все' : 'Barchasi',
            selected: filter.type == null,
            onTap: () => ref.read(movementFilterProvider.notifier).setType(null),
          ),
          ...MovementType.values.map((t) => Padding(
                padding: const EdgeInsets.only(left: AppDim.paddingXS),
                child: _Chip(
                  label: locale == 'ru' ? t.labelRu : t.labelUz,
                  selected: filter.type == t,
                  color: _colorFor(t),
                  onTap: () =>
                      ref.read(movementFilterProvider.notifier).setType(t),
                ),
              )),
        ],
      ),
    );
  }

  Color _colorFor(MovementType t) {
    switch (t) {
      case MovementType.inbound: return AppColors.movementIn;
      case MovementType.outbound: return AppColors.movementOut;
      case MovementType.adjustment:
      case MovementType.inventory: return AppColors.movementAdjustment;
      case MovementType.returned: return AppColors.movementReturn;
      case MovementType.damaged: return AppColors.movementDamaged;
      case MovementType.transfer: return AppColors.movementTransfer;
    }
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;
  const _Chip({required this.label, required this.selected, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? c : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDim.radiusRound),
          border: Border.all(color: selected ? c : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class MovementTile extends StatelessWidget {
  final StockMovementModel movement;
  const MovementTile({super.key, required this.movement});

  Color get _typeColor {
    switch (movement.movementType) {
      case MovementType.inbound: return AppColors.movementIn;
      case MovementType.outbound: return AppColors.movementOut;
      case MovementType.adjustment:
      case MovementType.inventory: return AppColors.movementAdjustment;
      case MovementType.returned: return AppColors.movementReturn;
      case MovementType.damaged: return AppColors.movementDamaged;
      case MovementType.transfer: return AppColors.movementTransfer;
    }
  }

  IconData get _typeIcon {
    switch (movement.movementType) {
      case MovementType.inbound: return Icons.arrow_circle_down_outlined;
      case MovementType.outbound: return Icons.arrow_circle_up_outlined;
      case MovementType.adjustment:
      case MovementType.inventory: return Icons.fact_check_outlined;
      case MovementType.returned: return Icons.undo;
      case MovementType.damaged: return Icons.broken_image_outlined;
      case MovementType.transfer: return Icons.swap_horiz;
    }
  }

  String get _qtyLabel {
    final sign = movement.movementType == MovementType.inbound ||
            movement.movementType == MovementType.returned
        ? '+'
        : movement.movementType == MovementType.adjustment
            ? (movement.afterQuantity > movement.beforeQuantity ? '+' : '-')
            : '-';
    return '$sign${movement.quantity}';
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final typeLabel = locale == 'ru'
        ? movement.movementType.labelRu
        : movement.movementType.labelUz;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDim.paddingM),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _typeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDim.radiusM),
              ),
              child: Icon(_typeIcon, color: _typeColor, size: 20),
            ),
            const SizedBox(width: AppDim.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movement.productName ?? movement.productId,
                    style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: _typeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(typeLabel,
                            style: AppTextStyles.caption
                                .copyWith(color: _typeColor, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: AppDim.paddingXS),
                      Text(
                        '${movement.beforeQuantity} -> ${movement.afterQuantity}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  if (movement.note != null)
                    Text(movement.note!, style: AppTextStyles.caption, maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _qtyLabel,
                  style: AppTextStyles.heading3.copyWith(
                    color: _typeColor,
                    fontSize: 16,
                  ),
                ),
                Text(
                  DateFormatter.formatDateTime(movement.createdAt),
                  style: AppTextStyles.caption,
                ),
                if (movement.createdByName != null)
                  Text(movement.createdByName!,
                      style: AppTextStyles.caption, maxLines: 1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
