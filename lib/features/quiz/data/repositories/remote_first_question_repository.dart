import '../../domain/entities/question.dart';
import '../../domain/entities/quiz_category.dart';
import '../../domain/repositories/question_repository.dart';
import '../datasources/open_trivia_question_data_source.dart';
import '../models/open_trivia_question_dto.dart';

class RemoteFirstQuestionRepository implements QuestionRepository {
  RemoteFirstQuestionRepository({
    required QuestionRepository localRepository,
    OpenTriviaQuestionDataSource? remoteDataSource,
  })  : _localRepository = localRepository,
        _remoteDataSource = remoteDataSource ?? OpenTriviaQuestionDataSource();

  final QuestionRepository _localRepository;
  final OpenTriviaQuestionDataSource _remoteDataSource;

  static const Map<String, int> _openTriviaCategories = {
    'computer_basics': 18,
    'nepal_gk': 22,
    'loksewa_gk': 9,
  };

  @override
  Future<List<Question>> loadQuestions(QuizCategory category) {
    return randomQuiz(category, count: 10);
  }

  @override
  Future<List<Question>> randomQuiz(QuizCategory category,
      {int count = 10}) async {
    final remoteCategoryId = _openTriviaCategories[category.id];
    if (remoteCategoryId == null) {
      return _localRepository.randomQuiz(category, count: count);
    }

    try {
      final remoteQuestions = await _remoteDataSource.fetchQuestions(
        amount: count,
        categoryId: remoteCategoryId,
      );
      if (remoteQuestions.isEmpty) {
        return _localRepository.randomQuiz(category, count: count);
      }

      return remoteQuestions.indexed.map((entry) {
        return OpenTriviaQuestionDto.fromJson(
          entry.$2,
          categoryId: category.id,
          index: entry.$1,
        );
      }).toList(growable: false);
    } on Object {
      return _localRepository.randomQuiz(category, count: count);
    }
  }
}
