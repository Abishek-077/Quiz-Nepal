class QuizResult {
  const QuizResult({
    required this.categoryId,
    required this.score,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.coinsEarned,
    required this.bestScore,
    required this.completedAt,
  });

  final String categoryId;
  final int score;
  final int correctAnswers;
  final int wrongAnswers;
  final int coinsEarned;
  final int bestScore;
  final DateTime completedAt;
}
