import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/enums.dart';

class StatusBadge extends StatelessWidget {
  final StockStatus status;
  final String? labelOverride;

  const StatusBadge({super.key, required this.status, this.labelOverride});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;

    switch (status) {
      case StockStatus.ok:
        color = AppColors.statusOk;
        label = labelOverride ?? 'Normal';
      case StockStatus.low:
        color = AppColors.statusLow;
        label = labelOverride ?? 'Kam';
      case StockStatus.critical:
        color = AppColors.statusCritical;
        label = labelOverride ?? "Tugagan";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
