import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/category_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.category,
    required this.onTap,
    this.compact = false,
    super.key,
  });

  final QuizCategory category;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.all(compact ? 14 : 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.text.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CategoryIcon(category: category, size: 44),
                  const SizedBox(height: 18),
                  Text(
                    _compactTitle(category.title),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  _CategoryIcon(category: category, size: 52),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            height: 1.18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          category.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 14,
                            height: 1.25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ],
              ),
      ),
    );
  }

  String _compactTitle(String title) {
    return title.replaceAll(' MCQ', '').replaceAll('General Knowledge', 'GK');
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category, this.size = 56});

  final QuizCategory category;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = category.gradient.first;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: category.gradient.last.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(category.icon, color: color, size: size * 0.48),
    );
  }
}
