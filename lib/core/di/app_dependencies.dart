import 'package:flutter/widgets.dart';

import '../../features/quiz/data/gateways/mock_ad_gateway.dart';
import '../../features/quiz/data/repositories/asset_question_repository.dart';
import '../../features/quiz/data/repositories/local_quiz_stats_repository.dart';
import '../../features/quiz/data/repositories/remote_first_question_repository.dart';
import '../../features/quiz/domain/repositories/ad_gateway.dart';
import '../../features/quiz/domain/repositories/question_repository.dart';
import '../../features/quiz/domain/repositories/quiz_stats_repository.dart';
import '../../features/quiz/domain/usecases/add_coins.dart';
import '../../features/quiz/domain/usecases/complete_quiz.dart';
import '../../features/quiz/domain/usecases/continue_quiz_with_reward.dart';
import '../../features/quiz/domain/usecases/double_coins_with_reward.dart';
import '../../features/quiz/domain/usecases/get_random_quiz_questions.dart';
import '../../features/quiz/domain/usecases/get_user_stats.dart';
import '../../features/quiz/domain/usecases/show_quiz_complete_ad.dart';
import '../../features/quiz/domain/usecases/unlock_full_explanation.dart';

class AppDependencies {
  AppDependencies({
    required this.questionRepository,
    required this.quizStatsRepository,
    required this.adGateway,
  });

  factory AppDependencies.defaults() {
    final localQuestionRepository = AssetQuestionRepository();
    return AppDependencies(
      questionRepository: RemoteFirstQuestionRepository(
        localRepository: localQuestionRepository,
      ),
      quizStatsRepository: LocalQuizStatsRepository(),
      adGateway: MockAdGateway(),
    );
  }

  final QuestionRepository questionRepository;
  final QuizStatsRepository quizStatsRepository;
  final AdGateway adGateway;

  GetRandomQuizQuestions get getRandomQuizQuestions =>
      GetRandomQuizQuestions(questionRepository);
  CompleteQuiz get completeQuiz => CompleteQuiz(quizStatsRepository);
  GetUserStats get getUserStats => GetUserStats(quizStatsRepository);
  AddCoins get addCoins => AddCoins(quizStatsRepository);
  DoubleCoinsWithReward get doubleCoinsWithReward =>
      DoubleCoinsWithReward(adGateway, quizStatsRepository);
  UnlockFullExplanation get unlockFullExplanation =>
      UnlockFullExplanation(adGateway);
  ContinueQuizWithReward get continueQuizWithReward =>
      ContinueQuizWithReward(adGateway);
  ShowQuizCompleteAd get showQuizCompleteAd => ShowQuizCompleteAd(adGateway);
}

class AppScope extends InheritedWidget {
  const AppScope({
    required this.dependencies,
    required super.child,
    super.key,
  });

  final AppDependencies dependencies;

  static AppDependencies of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope was not found in the widget tree.');
    return scope!.dependencies;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      dependencies != oldWidget.dependencies;
}
