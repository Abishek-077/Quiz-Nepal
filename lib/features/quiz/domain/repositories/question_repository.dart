import '../entities/question.dart';
import '../entities/quiz_category.dart';

abstract class QuestionRepository {
  Future<List<Question>> loadQuestions(QuizCategory category);

  Future<List<Question>> randomQuiz(QuizCategory category, {int count = 10});
}
