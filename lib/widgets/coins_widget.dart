import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class CoinsWidget extends StatelessWidget {
  const CoinsWidget({required this.coins, super.key});

  final int coins;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: AppColors.accent.withOpacity(0.2),
      avatar: const Icon(Icons.monetization_on, color: AppColors.accent),
      label: Text('$coins coins', style: const TextStyle(fontWeight: FontWeight.w800)),
      side: BorderSide.none,
    );
  }
}
