import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_battle_nepal/features/quiz/data/category_catalog.dart';
import 'package:quiz_battle_nepal/features/quiz/data/models/question_dto.dart';

void main() {
  test('QuestionDto.fromJson parses a valid question', () {
    final question = QuestionDto.fromJson({
      'id': 'dl_001',
      'category': 'driving_license',
      'subCategory': 'bike',
      'question': 'What should you do when the traffic light is red?',
      'options': [
        'Go fast',
        'Stop before the stop line',
        'Horn and move',
        'Turn immediately'
      ],
      'correctIndex': 1,
      'shortExplanation': 'Red light means stop.',
      'fullExplanation': 'Stop before the stop line until the signal changes.',
    });

    expect(question.id, 'dl_001');
    expect(question.options, hasLength(4));
    expect(question.correctIndex, 1);
  });

  test('QuestionDto.fromJson rejects malformed option and answer data', () {
    expect(
      () => QuestionDto.fromJson({
        'id': 'bad_001',
        'category': 'driving_license',
        'question': 'Bad question',
        'options': ['A', 'B'],
        'correctIndex': 5,
        'shortExplanation': 'Short',
        'fullExplanation': 'Full',
      }),
      throwsFormatException,
    );
  });

  test('local JSON question files are loadable and match their category', () {
    var total = 0;
    for (final category in CategoryCatalog.all) {
      final decoded = jsonDecode(File(category.assetPath).readAsStringSync())
          as List<dynamic>;
      final questions = decoded
          .map((item) => QuestionDto.fromJson(item as Map<String, dynamic>))
          .toList();
      expect(questions, hasLength(greaterThanOrEqualTo(10)));
      expect(questions.every((question) => question.category == category.id),
          isTrue);
      total += questions.length;
    }

    expect(total, greaterThanOrEqualTo(50));
  });
}
