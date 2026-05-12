import '../entities/quiz_result.dart';
import '../entities/user_stats.dart';

abstract class QuizStatsRepository {
  Future<QuizResult> completeQuiz({
    required String categoryId,
    required int score,
    required int correctAnswers,
    required int wrongAnswers,
    required int coinsEarned,
  });

  Future<UserStats> getUserStats();

  Future<void> addCoins(int amount);
}
