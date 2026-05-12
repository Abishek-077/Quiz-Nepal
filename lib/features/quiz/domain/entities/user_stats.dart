class UserStats {
  const UserStats({
    required this.totalCoins,
    required this.bestScore,
    required this.quizzesPlayed,
    required this.correctAnswers,
    required this.currentStreak,
  });

  const UserStats.empty()
      : totalCoins = 0,
        bestScore = 0,
        quizzesPlayed = 0,
        correctAnswers = 0,
        currentStreak = 0;

  final int totalCoins;
  final int bestScore;
  final int quizzesPlayed;
  final int correctAnswers;
  final int currentStreak;
}
