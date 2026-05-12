import 'dart:math';

import '../../domain/entities/question.dart';

class OpenTriviaQuestionDto {
  const OpenTriviaQuestionDto._();

  static Question fromJson(
    Map<String, dynamic> json, {
    required String categoryId,
    required int index,
    Random? random,
  }) {
    final questionText = _decodeRequiredString(json, 'question');
    final correctAnswer = _decodeRequiredString(json, 'correct_answer');
    final incorrectAnswersJson = json['incorrect_answers'];
    if (incorrectAnswersJson is! List<dynamic>) {
      throw FormatException(
          'OpenTDB question $index is missing incorrect answers.');
    }

    final incorrectAnswers = incorrectAnswersJson.map((answer) {
      if (answer is! String || answer.trim().isEmpty) {
        throw FormatException('OpenTDB question $index has an invalid answer.');
      }
      return Uri.decodeComponent(answer).trim();
    }).toList(growable: false);

    final options = [correctAnswer, ...incorrectAnswers]
      ..shuffle(random ?? Random());
    final correctIndex = options.indexOf(correctAnswer);

    return Question(
      id: 'opentdb_${categoryId}_${index}_${questionText.hashCode}',
      category: categoryId,
      subCategory: _decodeOptionalString(json, 'category') ?? 'opentdb',
      question: questionText,
      options: options,
      correctIndex: correctIndex,
      shortExplanation: 'Correct answer: $correctAnswer',
      fullExplanation:
          'This question was loaded from Open Trivia DB. Correct answer: $correctAnswer',
    );
  }

  static String _decodeRequiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('OpenTDB question is missing $key.');
    }
    return Uri.decodeComponent(value).trim();
  }

  static String? _decodeOptionalString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) {
      return Uri.decodeComponent(value).trim();
    }
    return null;
  }
}
