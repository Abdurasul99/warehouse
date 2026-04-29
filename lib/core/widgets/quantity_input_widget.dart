import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class QuantityInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? errorText;
  final int min;
  final int? max;
  final ValueChanged<String>? onChanged;

  const QuantityInputWidget({
    super.key,
    required this.controller,
    required this.label,
    this.errorText,
    this.min = 1,
    this.max,
    this.onChanged,
  });

  void _increment() {
    final current = int.tryParse(controller.text) ?? 0;
    if (max != null && current >= max!) return;
    controller.text = (current + 1).toString();
    onChanged?.call(controller.text);
  }

  void _decrement() {
    final current = int.tryParse(controller.text) ?? min;
    if (current <= min) return;
    controller.text = (current - 1).toString();
    onChanged?.call(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppDim.paddingXS),
        Row(
          children: [
            _StepButton(icon: Icons.remove, onTap: _decrement),
            const SizedBox(width: AppDim.paddingS),
            Expanded(
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: onChanged,
                decoration: InputDecoration(
                  errorText: errorText,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: AppDim.paddingM),
                ),
              ),
            ),
            const SizedBox(width: AppDim.paddingS),
            _StepButton(icon: Icons.add, onTap: _increment),
          ],
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDim.radiusM),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppDim.radiusM),
          color: AppColors.surface,
        ),
        child: Icon(icon, size: AppDim.iconSizeM, color: AppColors.primary),
      ),
    );
  }
}
