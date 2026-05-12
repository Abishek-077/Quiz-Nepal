import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class ExplanationCard extends StatelessWidget {
  const ExplanationCard({
    required this.shortExplanation,
    required this.onUnlock,
    this.fullExplanation,
    this.isUnlocking = false,
    super.key,
  });

  final String shortExplanation;
  final String? fullExplanation;
  final bool isUnlocking;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.accent),
              SizedBox(width: 8),
              Text('Explanation',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Text(shortExplanation,
              style: const TextStyle(fontWeight: FontWeight.w700)),
          if (fullExplanation != null) ...[
            const Divider(height: 22),
            Text(fullExplanation!),
          ] else ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: isUnlocking ? null : onUnlock,
              icon: isUnlocking
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.ondemand_video),
              label: const Text('Unlock full explanation'),
            ),
          ],
        ],
      ),
    );
  }
}
