import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _totalCoinsKey = 'totalCoins';
  static const _bestScoreKey = 'bestScore';
  static const _quizzesPlayedKey = 'quizzesPlayed';
  static const _correctAnswersKey = 'correctAnswers';
  static const _currentStreakKey = 'currentStreak';

  Future<int> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  Future<int> get totalCoins => getInt(_totalCoinsKey);
  Future<int> get bestScore => getInt(_bestScoreKey);
  Future<int> get quizzesPlayed => getInt(_quizzesPlayedKey);
  Future<int> get correctAnswers => getInt(_correctAnswersKey);
  Future<int> get currentStreak => getInt(_currentStreakKey);

  Future<void> saveQuizStats({
    required int score,
    required int coinsEarned,
    required int correctAnswers,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final previousBest = prefs.getInt(_bestScoreKey) ?? 0;
    final safeCoinsEarned = coinsEarned < 0 ? 0 : coinsEarned;
    final safeCorrectAnswers = correctAnswers < 0 ? 0 : correctAnswers;

    await Future.wait([
      prefs.setInt(_totalCoinsKey, (prefs.getInt(_totalCoinsKey) ?? 0) + safeCoinsEarned),
      prefs.setInt(_quizzesPlayedKey, (prefs.getInt(_quizzesPlayedKey) ?? 0) + 1),
      prefs.setInt(_correctAnswersKey, (prefs.getInt(_correctAnswersKey) ?? 0) + safeCorrectAnswers),
      prefs.setInt(_bestScoreKey, score > previousBest ? score : previousBest),
      prefs.setInt(_currentStreakKey, prefs.getInt(_currentStreakKey) ?? 0),
    ]);
  }

  Future<void> addCoins(int amount) async {
    if (amount <= 0) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalCoinsKey, (prefs.getInt(_totalCoinsKey) ?? 0) + amount);
  }
}
