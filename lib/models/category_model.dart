import 'package:flutter/material.dart';

class QuizCategory {
  const QuizCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.icon,
    required this.gradient,
  });

  final String id;
  final String title;
  final String subtitle;
  final String assetPath;
  final IconData icon;
  final List<Color> gradient;
}
