import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../models/category_model.dart';
import '../models/question_model.dart';

class QuestionService {
  QuestionService({AssetBundle? bundle, Random? random})
      : _bundle = bundle ?? rootBundle,
        _random = random ?? Random();

  final AssetBundle _bundle;
  final Random _random;

  Future<List<Question>> loadQuestions(QuizCategory category) async {
    try {
      final raw = await _bundle.loadString(category.assetPath);
      final decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) {
        throw const FormatException('Question file must contain a JSON array.');
      }

      return decoded
          .map((item) {
            if (item is! Map<String, dynamic>) {
              throw const FormatException('Each question must be a JSON object.');
            }
            final question = Question.fromJson(item);
            if (question.category != category.id) {
              throw FormatException(
                'Question ${question.id} category "${question.category}" does not match ${category.id}.',
              );
            }
            return question;
          })
          .toList(growable: false);
    } on FormatException catch (error) {
      throw QuestionLoadException(category.assetPath, error.message);
    } on Object catch (error) {
      throw QuestionLoadException(category.assetPath, error.toString());
    }
  }

  Future<List<Question>> randomQuiz(QuizCategory category, {int count = 10}) async {
    if (count <= 0) {
      throw ArgumentError.value(count, 'count', 'Quiz question count must be positive.');
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
