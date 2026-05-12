import '../repositories/quiz_stats_repository.dart';

class AddCoins {
  const AddCoins(this._repository);

  final QuizStatsRepository _repository;

  Future<void> call(int amount) => _repository.addCoins(amount);
}
