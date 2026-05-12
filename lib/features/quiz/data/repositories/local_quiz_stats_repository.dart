import '../../domain/entities/quiz_result.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/repositories/quiz_stats_repository.dart';
import '../datasources/local_quiz_stats_data_source.dart';

class LocalQuizStatsRepository implements QuizStatsRepository {
  LocalQuizStatsRepository({LocalQuizStatsDataSource? dataSource})
      : _dataSource = dataSource ?? LocalQuizStatsDataSource();

  final LocalQuizStatsDataSource _dataSource;

  @override
  Future<QuizResult> completeQuiz({
    required String categoryId,
    required int score,
    required int correctAnswers,
    required int wrongAnswers,
    required int coinsEarned,
  }) async {
    await _dataSource.saveQuizStats(
      score: score,
      coinsEarned: coinsEarned,
      correctAnswers: correctAnswers,
    );

    return QuizResult(
      categoryId: categoryId,
      score: score,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      coinsEarned: coinsEarned,
      bestScore: await _dataSource.getBestScore(),
      completedAt: DateTime.now(),
    );
  }

  @override
  Future<UserStats> getUserStats() => _dataSource.getUserStats();

  @override
  Future<void> addCoins(int amount) => _dataSource.addCoins(amount);
}
