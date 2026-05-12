import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_stats.dart';

class LocalQuizStatsDataSource {
  static const totalCoinsKey = 'totalCoins';
  static const bestScoreKey = 'bestScore';
  static const quizzesPlayedKey = 'quizzesPlayed';
  static const correctAnswersKey = 'correctAnswers';
  static const currentStreakKey = 'currentStreak';

  Future<UserStats> getUserStats() async {
    final prefs = await SharedPreferences.getInstance();
    return UserStats(
      totalCoins: prefs.getInt(totalCoinsKey) ?? 0,
      bestScore: prefs.getInt(bestScoreKey) ?? 0,
      quizzesPlayed: prefs.getInt(quizzesPlayedKey) ?? 0,
      correctAnswers: prefs.getInt(correctAnswersKey) ?? 0,
      currentStreak: prefs.getInt(currentStreakKey) ?? 0,
    );
  }

  Future<int> getBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(bestScoreKey) ?? 0;
  }

  Future<int> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  Future<int> get totalCoins => getInt(totalCoinsKey);
  Future<int> get bestScore => getInt(bestScoreKey);
  Future<int> get quizzesPlayed => getInt(quizzesPlayedKey);
  Future<int> get correctAnswers => getInt(correctAnswersKey);
  Future<int> get currentStreak => getInt(currentStreakKey);

  Future<void> saveQuizStats({
    required int score,
    required int coinsEarned,
    required int correctAnswers,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final previousBest = prefs.getInt(bestScoreKey) ?? 0;
    final safeCoinsEarned = coinsEarned < 0 ? 0 : coinsEarned;
    final safeCorrectAnswers = correctAnswers < 0 ? 0 : correctAnswers;

    await Future.wait([
      prefs.setInt(
          totalCoinsKey, (prefs.getInt(totalCoinsKey) ?? 0) + safeCoinsEarned),
      prefs.setInt(quizzesPlayedKey, (prefs.getInt(quizzesPlayedKey) ?? 0) + 1),
      prefs.setInt(correctAnswersKey,
          (prefs.getInt(correctAnswersKey) ?? 0) + safeCorrectAnswers),
      prefs.setInt(bestScoreKey, score > previousBest ? score : previousBest),
      prefs.setInt(currentStreakKey, prefs.getInt(currentStreakKey) ?? 0),
    ]);
  }

  Future<void> addCoins(int amount) async {
    if (amount <= 0) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        totalCoinsKey, (prefs.getInt(totalCoinsKey) ?? 0) + amount);
  }
}
