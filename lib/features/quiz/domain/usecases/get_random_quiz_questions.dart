import '../entities/question.dart';
import '../entities/quiz_category.dart';
import '../repositories/question_repository.dart';

class GetRandomQuizQuestions {
  const GetRandomQuizQuestions(this._repository);

  final QuestionRepository _repository;

  Future<List<Question>> call(QuizCategory category, {int count = 10}) {
    return _repository.randomQuiz(category, count: count);
  }
}
