import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/category_model.dart';

class CategoryCatalog {
  const CategoryCatalog._();

  static const List<QuizCategory> all = [
    QuizCategory(
      id: 'driving_license',
      title: 'Driving License MCQ',
      subtitle: 'Rules, signals and safe riding',
      assetPath: 'lib/data/questions/driving_license.json',
      icon: Icons.two_wheeler,
      gradient: [AppColors.primary, AppColors.danger],
    ),
    QuizCategory(
      id: 'traffic_signs',
      title: 'Traffic Signs',
      subtitle: 'Recognize road signs faster',
      assetPath: 'lib/data/questions/traffic_signs.json',
      icon: Icons.traffic,
      gradient: [Color(0xFFFF8A00), AppColors.accent],
    ),
    QuizCategory(
      id: 'loksewa_gk',
      title: 'Loksewa GK',
      subtitle: 'Public service prep essentials',
      assetPath: 'lib/data/questions/loksewa_gk.json',
      icon: Icons.account_balance,
      gradient: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
    ),
    QuizCategory(
      id: 'computer_basics',
      title: 'Computer Basics',
      subtitle: 'IT basics for exams and life',
      assetPath: 'lib/data/questions/computer_basics.json',
      icon: Icons.computer,
      gradient: [Color(0xFF0EA5E9), Color(0xFF0369A1)],
    ),
    QuizCategory(
      id: 'nepal_gk',
      title: 'Nepal General Knowledge',
      subtitle: 'Geography, culture and history',
      assetPath: 'lib/data/questions/nepal_gk.json',
      icon: Icons.flag,
      gradient: [AppColors.success, Color(0xFF047857)],
    ),
  ];

  static QuizCategory byId(String id) {
    return all.firstWhere(
      (category) => category.id == id,
      orElse: () => all.first,
    );
  }

  static QuizCategory dailyCategory(DateTime date) {
    final normalizedDay = DateTime(date.year, date.month, date.day);
    final index = normalizedDay.difference(DateTime(2024)).inDays % all.length;
    return all[index];
  }
}
