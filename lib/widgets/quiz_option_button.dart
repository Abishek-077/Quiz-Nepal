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
    super.key,
  });

  final String label;
  final String text;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.transparent;
    Color backgroundColor = AppColors.card;
    IconData? trailingIcon;

    if (showResult && isCorrect) {
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
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.6),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.secondary,
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            if (trailingIcon != null) Icon(trailingIcon, color: borderColor),
          ],
        ),
      ),
    );
  }
}
