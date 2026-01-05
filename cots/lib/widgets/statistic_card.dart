import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/typography.dart';
import '../design_system/spacing.dart';

class StatisticCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const StatisticCard({
    super.key,
    required this.label,
    required this.value,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: textColor ?? AppColors.textSecondary,
                  ),
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  color: textColor ?? AppColors.textSecondary,
                  size: 16,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.heading1.copyWith(
              color: textColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
