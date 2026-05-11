import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_battle_nepal/services/quiz_engine.dart';

void main() {
  test('correct answer adds score, coins, and answered count', () {
    final engine = QuizEngine()..start();

    final isCorrect = engine.answer(selectedIndex: 2, correctIndex: 2);

    expect(isCorrect, isTrue);
    expect(engine.score, QuizEngine.pointsPerCorrectAnswer);
    expect(engine.coinsEarned, QuizEngine.coinsPerCorrectAnswer);
    expect(engine.correctAnswers, 1);
    expect(engine.answeredQuestions, 1);
    expect(engine.hearts, QuizEngine.defaultStartingHearts);
  });

  test('wrong answer removes one heart and tracks wrong answers', () {
    final engine = QuizEngine()..start();

    final isCorrect = engine.answer(selectedIndex: 0, correctIndex: 2);

    expect(isCorrect, isFalse);
    expect(engine.score, 0);
    expect(engine.coinsEarned, 0);
    expect(engine.wrongAnswers, 1);
    expect(engine.answeredQuestions, 1);
    expect(engine.hearts, QuizEngine.defaultStartingHearts - 1);
  });

  test('hearts do not go below zero and game-over answers are ignored', () {
    final engine = QuizEngine()..start();

    for (var i = 0; i < 8; i++) {
      engine.answer(selectedIndex: 0, correctIndex: 1);
    }

    expect(engine.hearts, 0);
    expect(engine.wrongAnswers, QuizEngine.defaultStartingHearts);
    expect(engine.answeredQuestions, QuizEngine.defaultStartingHearts);
    expect(engine.hasHearts, isFalse);
  });

  test('rewarded continue restores limited hearts without changing score', () {
    final engine = QuizEngine()..start();

    for (var i = 0; i < QuizEngine.defaultStartingHearts; i++) {
      engine.answer(selectedIndex: 0, correctIndex: 1);
    }

    engine.restoreHearts(QuizEngine.rewardedContinueHearts);

    expect(engine.hearts, QuizEngine.rewardedContinueHearts);
    expect(engine.score, 0);
    expect(engine.hasHearts, isTrue);
  });
}
