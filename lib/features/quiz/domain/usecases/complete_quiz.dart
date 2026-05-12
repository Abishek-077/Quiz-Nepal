import '../entities/quiz_result.dart';
import '../repositories/quiz_stats_repository.dart';

class CompleteQuiz {
  const CompleteQuiz(this._repository);

  final QuizStatsRepository _repository;

  Future<QuizResult> call({
    required String categoryId,
    required int score,
    required int correctAnswers,
    required int wrongAnswers,
    required int coinsEarned,
  }) {
    return _repository.completeQuiz(
      categoryId: categoryId,
      score: score,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      coinsEarned: coinsEarned,
    );
  }
}
