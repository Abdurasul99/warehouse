import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/analytics_summary.dart';

class FlowValueRowWidget extends StatelessWidget {
  final FlowDelta flow;
  final double inventoryValue;

  const FlowValueRowWidget({
    super.key,
    required this.flow,
    required this.inventoryValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _FlowCard(flow: flow)),
        const SizedBox(width: AppDim.paddingM),
        Expanded(child: _ValueCard(value: inventoryValue)),
      ],
    );
  }
}

class _FlowCard extends StatelessWidget {
  final FlowDelta flow;
  const _FlowCard({required this.flow});

  Color _color() => switch (flow.level) {
        HealthLevel.green => AppColors.statusOk,
        HealthLevel.yellow => AppColors.statusLow,
        HealthLevel.red => AppColors.statusCritical,
      };

  IconData _arrow() => flow.net > 0
      ? Icons.trending_up
      : flow.net < 0
          ? Icons.trending_down
          : Icons.trending_flat;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = _color();
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
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.analytics_flow_title,
                  style: AppTextStyles.label,
                ),
              ),
              Icon(_arrow(), color: color, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            (flow.net >= 0 ? '+' : '') + flow.net.toString(),
            style: AppTextStyles.heading1.copyWith(color: color, fontSize: 22),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _MiniStat(
                label: l10n.analytics_flow_in,
                value: flow.unitsIn,
                color: AppColors.statusOk,
              ),
              const SizedBox(width: AppDim.paddingS),
              _MiniStat(
                label: l10n.analytics_flow_out,
                value: flow.unitsOut,
                color: AppColors.statusCritical,
              ),
            ],
          ),
          if (flow.fromFallback) ...[
            const SizedBox(height: 4),
            Text(
              l10n.analytics_flow_fallback(
                DateFormat('dd.MM').format(flow.referenceDay),
              ),
              style: AppTextStyles.caption,
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text('$label: $value', style: AppTextStyles.caption),
      ],
    );
  }
}

class _ValueCard extends StatelessWidget {
  final double value;
  const _ValueCard({required this.value});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formatter = NumberFormat.decimalPattern();
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
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.analytics_value_title,
                  style: AppTextStyles.label,
                ),
              ),
              const Icon(Icons.account_balance_wallet_outlined,
                  color: AppColors.primary, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            formatter.format(value.round()),
            style: AppTextStyles.heading1.copyWith(
              color: AppColors.textPrimary,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "soʻm · ${l10n.analytics_value_subtitle}",
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
