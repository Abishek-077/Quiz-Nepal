import '../entities/user_stats.dart';
import '../repositories/quiz_stats_repository.dart';

class GetUserStats {
  const GetUserStats(this._repository);

  final QuizStatsRepository _repository;

  Future<UserStats> call() => _repository.getUserStats();
}
