import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_battle_nepal/features/quiz/data/models/open_trivia_question_dto.dart';

void main() {
  test('OpenTriviaQuestionDto maps encoded API response to app question', () {
    final question = OpenTriviaQuestionDto.fromJson(
      {
        'category': 'Science%3A%20Computers',
        'question': 'What%20does%20CPU%20stand%20for%3F',
        'correct_answer': 'Central%20Processing%20Unit',
        'incorrect_answers': [
          'Computer%20Personal%20Unit',
          'Central%20Process%20Utility',
          'Control%20Processing%20Unit',
        ],
      },
      categoryId: 'computer_basics',
      index: 0,
    );

    expect(question.category, 'computer_basics');
    expect(question.subCategory, 'Science: Computers');
    expect(question.question, 'What does CPU stand for?');
    expect(question.options, contains('Central Processing Unit'));
    expect(question.options[question.correctIndex], 'Central Processing Unit');
  });
}
