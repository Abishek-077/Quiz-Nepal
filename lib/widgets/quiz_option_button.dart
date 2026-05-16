import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class QuizOptionButton extends StatelessWidget {
  const QuizOptionButton({
    required this.label,
    required this.text,
    required this.onTap,
    this.isSelected = false,
    this.isCorrect = false,
    this.showResult = false,
    this.leadingIcon,
    super.key,
  });

  final String label;
  final String text;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final Widget? leadingIcon;

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.border;
    Color backgroundColor = AppColors.card;
    IconData? trailingIcon;

    if (!showResult && isSelected) {
      borderColor = AppColors.secondary;
      backgroundColor = AppColors.secondary.withValues(alpha: 0.06);
    } else if (showResult && isCorrect) {
      backgroundColor = AppColors.success.withValues(alpha: 0.14);
      borderColor = AppColors.success;
      trailingIcon = Icons.check_circle;
    } else if (showResult && isSelected && !isCorrect) {
      backgroundColor = AppColors.danger.withValues(alpha: 0.14);
      borderColor = AppColors.danger;
      trailingIcon = Icons.cancel;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.text.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            leadingIcon ??
                CircleAvatar(
                  radius: 23,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(text,
                  style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 18,
                      height: 1.25,
                      fontWeight: FontWeight.w800)),
            ),
            if (trailingIcon != null) Icon(trailingIcon, color: borderColor),
          ],
        ),
      ),
    );
  }
}
