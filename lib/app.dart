import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';

class QuizBattleNepalApp extends StatelessWidget {
  const QuizBattleNepalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: AppTheme.light(),
      home: const SplashScreen(),
    );
  }
}
