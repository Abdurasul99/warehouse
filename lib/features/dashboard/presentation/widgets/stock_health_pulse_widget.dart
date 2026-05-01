import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/analytics_summary.dart';

class StockHealthPulseWidget extends StatelessWidget {
  final StockHealthBreakdown health;
  final int slowMoverCount;

  const StockHealthPulseWidget({
    super.key,
    required this.health,
    required this.slowMoverCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                  l10n.analytics_health_title,
                  style: AppTextStyles.heading3,
                ),
              ),
              _LevelDot(level: health.level),
            ],
          ),
          const SizedBox(height: AppDim.paddingS),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDim.radiusS),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  if (health.okRatio > 0)
                    Expanded(
                      flex: (health.okRatio * 1000).round(),
                      child: Container(color: AppColors.statusOk),
                    ),
                  if (health.lowRatio > 0)
                    Expanded(
                      flex: (health.lowRatio * 1000).round(),
                      child: Container(color: AppColors.statusLow),
                    ),
                  if (health.criticalRatio > 0)
                    Expanded(
                      flex: (health.criticalRatio * 1000).round(),
                      child: Container(color: AppColors.statusCritical),
                    ),
                  if (health.total == 0)
                    Expanded(
                      child: Container(color: AppColors.divider),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDim.paddingM),
          Row(
            children: [
              _Legend(
                color: AppColors.statusOk,
                label: l10n.analytics_health_ok,
                value: health.okCount,
              ),
              const SizedBox(width: AppDim.paddingM),
              _Legend(
                color: AppColors.statusLow,
                label: l10n.analytics_health_low,
                value: health.lowCount,
              ),
              const SizedBox(width: AppDim.paddingM),
              _Legend(
                color: AppColors.statusCritical,
                label: l10n.analytics_health_critical,
                value: health.criticalCount,
              ),
            ],
          ),
          if (slowMoverCount > 0) ...[
            const SizedBox(height: AppDim.paddingM),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDim.paddingS, vertical: AppDim.paddingXS),
              decoration: BoxDecoration(
                color: AppColors.statusLow.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDim.radiusRound),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule_outlined,
                      size: 14, color: AppColors.statusLow),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      l10n.analytics_slow_movers_chip(slowMoverCount),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.statusLow,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LevelDot extends StatelessWidget {
  final HealthLevel level;
  const _LevelDot({required this.level});

  @override
  Widget build(BuildContext context) {
    final color = switch (level) {
      HealthLevel.green => AppColors.statusOk,
      HealthLevel.yellow => AppColors.statusLow,
      HealthLevel.red => AppColors.statusCritical,
    };
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  final int value;

  const _Legend({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.toString(),
                  style: AppTextStyles.heading3.copyWith(fontSize: 14),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
