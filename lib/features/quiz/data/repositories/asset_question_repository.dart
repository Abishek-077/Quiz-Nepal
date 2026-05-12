import 'dart:convert';
import 'dart:math';

import '../../domain/entities/question.dart';
import '../../domain/entities/quiz_category.dart';
import '../../domain/repositories/question_repository.dart';
import '../datasources/asset_question_data_source.dart';
import '../models/question_dto.dart';

class AssetQuestionRepository implements QuestionRepository {
  AssetQuestionRepository({
    AssetQuestionDataSource? dataSource,
    Random? random,
  })  : _dataSource = dataSource ?? AssetQuestionDataSource(),
        _random = random ?? Random();

  final AssetQuestionDataSource _dataSource;
  final Random _random;

  @override
  Future<List<Question>> loadQuestions(QuizCategory category) async {
    try {
      final raw = await _dataSource.loadQuestionJson(category.assetPath);
      final decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) {
        throw const FormatException('Question file must contain a JSON array.');
      }

      return decoded.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Each question must be a JSON object.');
        }
        final question = QuestionDto.fromJson(item);
        if (question.category != category.id) {
          throw FormatException(
            'Question ${question.id} category "${question.category}" does not match ${category.id}.',
          );
        }
        return question;
      }).toList(growable: false);
    } on FormatException catch (error) {
      throw QuestionLoadException(category.assetPath, error.message);
    } on Object catch (error) {
      throw QuestionLoadException(category.assetPath, error.toString());
    }
  }

  @override
  Future<List<Question>> randomQuiz(QuizCategory category,
      {int count = 10}) async {
    if (count <= 0) {
      throw ArgumentError.value(
          count, 'count', 'Quiz question count must be positive.');
    }

    final questions = [...await loadQuestions(category)]..shuffle(_random);
    return questions.take(min(count, questions.length)).toList(growable: false);
  }
}

class QuestionLoadException implements Exception {
  const QuestionLoadException(this.assetPath, this.message);

  final String assetPath;
  final String message;

  @override
  String toString() => 'QuestionLoadException($assetPath): $message';
}
