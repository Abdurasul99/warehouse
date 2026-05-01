import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';

class ActionRequiredBannerWidget extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const ActionRequiredBannerWidget({
    super.key,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isClear = count == 0;
    final color = isClear ? AppColors.statusOk : AppColors.statusCritical;
    final bg = color.withValues(alpha: 0.10);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppDim.radiusL),
      child: InkWell(
        onTap: isClear ? null : onTap,
        borderRadius: BorderRadius.circular(AppDim.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppDim.paddingM),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isClear ? Icons.verified_outlined : Icons.priority_high,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppDim.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.analytics_action_title,
                      style: AppTextStyles.heading3.copyWith(
                        color: color,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isClear
                          ? l10n.analytics_action_clear
                          : l10n.analytics_action_count(count),
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isClear)
                Icon(Icons.arrow_forward, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
