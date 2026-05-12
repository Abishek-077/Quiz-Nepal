import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/app_dependencies.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    AppScope(
      dependencies: AppDependencies.defaults(),
      child: const QuizBattleNepalApp(),
    ),
  );
}
