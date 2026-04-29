import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final VoidCallback onTap;
  final String? badge;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.color,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppDim.radiusL),
      elevation: AppDim.cardElevation,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDim.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppDim.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppDim.radiusM),
                    ),
                    child: Icon(icon, color: color, size: AppDim.iconSizeM),
                  ),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.statusCritical.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppDim.radiusRound),
                      ),
                      child: Text(
                        badge!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.statusCritical,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 14)),
              if (subtitle != null)
                Text(subtitle!, style: AppTextStyles.body2),
            ],
          ),
        ),
      ),
    );
  }
}
