import '../models/quiz_result_model.dart';
import 'storage_service.dart';

class ScoreService {
  ScoreService({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  final StorageService _storageService;

  Future<QuizResult> completeQuiz({
    required String categoryId,
    required int score,
    required int correctAnswers,
    required int wrongAnswers,
    required int coinsEarned,
  }) async {
    await _storageService.saveQuizStats(
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
      bestScore: await _storageService.bestScore,
      completedAt: DateTime.now(),
    );
  }

  Future<void> addCoins(int amount) => _storageService.addCoins(amount);
}
