import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../domain/entities/quiz_category.dart';

class CategoryCatalog {
  const CategoryCatalog._();

  static const List<QuizCategory> all = [
    QuizCategory(
      id: 'driving_license',
      title: 'Driving License MCQ',
      subtitle: 'Car, Bike, Scooter',
      assetPath: 'lib/data/questions/driving_license.json',
      icon: Icons.directions_car,
      gradient: [Color(0xFF7DA1FF), Color(0xFFDCE5FF)],
    ),
    QuizCategory(
      id: 'traffic_signs',
      title: 'Traffic Signs',
      subtitle: 'Mandatory, Warning, Information',
      assetPath: 'lib/data/questions/traffic_signs.json',
      icon: Icons.traffic,
      gradient: [Color(0xFFFFC8C8), Color(0xFFFFEFEF)],
    ),
    QuizCategory(
      id: 'loksewa_gk',
      title: 'Loksewa General Knowledge',
      subtitle: 'Federal & Provincial',
      assetPath: 'lib/data/questions/loksewa_gk.json',
      icon: Icons.gavel,
      gradient: [Color(0xFF008E87), Color(0xFFD9FFFC)],
    ),
    QuizCategory(
      id: 'computer_basics',
      title: 'Computer Basics',
      subtitle: 'Hardware, Software, Internet',
      assetPath: 'lib/data/questions/computer_basics.json',
      icon: Icons.computer,
      gradient: [Color(0xFFDCE5FF), Color(0xFFF1F5FF)],
    ),
    QuizCategory(
      id: 'nepal_gk',
      title: 'Nepal General Knowledge',
      subtitle: 'History, Geography, Culture',
      assetPath: 'lib/data/questions/nepal_gk.json',
      icon: Icons.landscape,
      gradient: [AppColors.secondary, Color(0xFFE8EEFF)],
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
