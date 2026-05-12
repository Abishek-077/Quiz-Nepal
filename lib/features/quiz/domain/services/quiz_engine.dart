class QuizEngine {
  QuizEngine({this.startingHearts = defaultStartingHearts}) {
    start();
  }

  static const int defaultStartingHearts = 5;
  static const int pointsPerCorrectAnswer = 10;
  static const int coinsPerCorrectAnswer = 2;
  static const int rewardedContinueHearts = 2;

  final int startingHearts;
  int score = 0;
  int hearts = defaultStartingHearts;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  int coinsEarned = 0;
  int answeredQuestions = 0;

  void start() {
    score = 0;
    hearts = startingHearts;
    correctAnswers = 0;
    wrongAnswers = 0;
    coinsEarned = 0;
    answeredQuestions = 0;
  }

  bool answer({required int selectedIndex, required int correctIndex}) {
    if (!hasHearts) {
      return false;
    }

    answeredQuestions += 1;
    final isCorrect = selectedIndex == correctIndex;
    if (isCorrect) {
      score += pointsPerCorrectAnswer;
      correctAnswers += 1;
      coinsEarned += coinsPerCorrectAnswer;
    } else {
      wrongAnswers += 1;
      hearts = (hearts - 1).clamp(0, startingHearts).toInt();
    }
    return isCorrect;
  }

  void restoreHearts(int amount) {
    if (amount <= 0) return;
    hearts = amount.clamp(0, startingHearts).toInt();
  }

  bool get hasHearts => hearts > 0;
}
