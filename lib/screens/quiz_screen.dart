import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/di/app_dependencies.dart';
import '../features/quiz/domain/entities/question.dart';
import '../features/quiz/domain/entities/quiz_category.dart';
import '../features/quiz/domain/services/quiz_engine.dart';
import '../features/quiz/domain/usecases/complete_quiz.dart';
import '../features/quiz/domain/usecases/continue_quiz_with_reward.dart';
import '../features/quiz/domain/usecases/get_random_quiz_questions.dart';
import '../features/quiz/domain/usecases/show_quiz_complete_ad.dart';
import '../features/quiz/domain/usecases/unlock_full_explanation.dart';
import '../widgets/app_chrome.dart';
import '../widgets/quiz_option_button.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({required this.category, super.key});

  final QuizCategory category;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _engine = QuizEngine();

  late GetRandomQuizQuestions _getRandomQuizQuestions;
  late CompleteQuiz _completeQuiz;
  late ShowQuizCompleteAd _showQuizCompleteAd;
  late UnlockFullExplanation _unlockFullExplanation;
  late ContinueQuizWithReward _continueQuizWithReward;

  List<Question> _questions = [];
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _hasSubmitted = false;
  bool _hasLoadedDependencies = false;
  bool _isLoading = true;
  bool _isUnlocking = false;
  bool _isContinuing = false;
  bool _isFinishing = false;
  String? _loadError;
  String? _fullExplanation;

  Question get _currentQuestion => _questions[_currentIndex];
  bool get _hasAnswered => _hasSubmitted;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoadedDependencies) return;
    final dependencies = AppScope.of(context);
    _getRandomQuizQuestions = dependencies.getRandomQuizQuestions;
    _completeQuiz = dependencies.completeQuiz;
    _showQuizCompleteAd = dependencies.showQuizCompleteAd;
    _unlockFullExplanation = dependencies.unlockFullExplanation;
    _continueQuizWithReward = dependencies.continueQuizWithReward;
    _hasLoadedDependencies = true;
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
      _questions = [];
      _currentIndex = 0;
      _selectedIndex = null;
      _hasSubmitted = false;
      _fullExplanation = null;
      _engine.start();
    });

    try {
      final questions = await _getRandomQuizQuestions(widget.category);
      if (!mounted) return;
      setState(() {
        _questions = questions;
        _isLoading = false;
        if (questions.isEmpty) {
          _loadError = 'No questions found for ${widget.category.title} yet.';
        }
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = error.toString();
      });
    }
  }

  void _select(int index) {
    if (_hasAnswered || !_engine.hasHearts || _isFinishing) return;
    setState(() => _selectedIndex = index);
  }

  void _submit() {
    if (_selectedIndex == null ||
        _hasAnswered ||
        !_engine.hasHearts ||
        _isFinishing) {
      return;
    }
    setState(() {
      _hasSubmitted = true;
      _engine.answer(
        selectedIndex: _selectedIndex!,
        correctIndex: _currentQuestion.correctIndex,
      );
    });
  }

  Future<void> _next() async {
    if (!_hasAnswered || _isFinishing) return;

    if (_currentIndex == _questions.length - 1 || !_engine.hasHearts) {
      await _finishQuiz();
      return;
    }

    setState(() {
      _currentIndex += 1;
      _selectedIndex = null;
      _hasSubmitted = false;
      _fullExplanation = null;
      _isUnlocking = false;
    });
  }

  Future<void> _finishQuiz() async {
    if (_isFinishing) return;
    setState(() => _isFinishing = true);

    try {
      await _showQuizCompleteAd();
      final result = await _completeQuiz(
        categoryId: widget.category.id,
        score: _engine.score,
        correctAnswers: _engine.correctAnswers,
        wrongAnswers: _engine.wrongAnswers,
        coinsEarned: _engine.coinsEarned,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) =>
              ResultScreen(result: result, category: widget.category),
        ),
      );
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _isFinishing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save result yet: $error')),
      );
    }
  }

  Future<void> _unlockExplanation() async {
    if (_isUnlocking || _fullExplanation != null) return;
    setState(() => _isUnlocking = true);
    final explanation = await _unlockFullExplanation(_currentQuestion);
    if (!mounted) return;
    setState(() {
      _fullExplanation = explanation;
      _isUnlocking = false;
    });
  }

  Future<void> _continueWithReward() async {
    if (_isContinuing || _engine.hasHearts) return;
    setState(() => _isContinuing = true);
    await _continueQuizWithReward(_engine);
    if (!mounted) return;
    setState(() => _isContinuing = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const BattleHeader(showBack: true),
            Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: widget.category.gradient.first,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_loadError != null || _questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const BattleHeader(showBack: true),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.danger,
                        size: 54,
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Could not start this quiz',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _loadError ?? 'No questions found for this category.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton.icon(
                        onPressed: _loadQuiz,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final progress = (_currentIndex + 1) / _questions.length;
    final question = _currentQuestion;
    final shouldFinish =
        _currentIndex == _questions.length - 1 || !_engine.hasHearts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          BattleHeader(
            showBack: true,
            score: _engine.score,
            hearts: _engine.hearts,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(22, 34, 22, _hasAnswered ? 330 : 24),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PROGRESS',
                            style: TextStyle(
                              color: AppColors.muted,
                              letterSpacing: 2.2,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Question ${_currentIndex + 1} of ${_questions.length}',
                            style: const TextStyle(
                              color: AppColors.text,
                              fontSize: 27,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.timer_outlined, color: AppColors.primary),
                    const SizedBox(width: 6),
                    const Text(
                      '15s',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    color: AppColors.primary,
                    backgroundColor:
                        AppColors.secondary.withValues(alpha: 0.16),
                  ),
                ),
                const SizedBox(height: 36),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    question.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.22,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                ...List.generate(question.options.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: QuizOptionButton(
                      label: String.fromCharCode(65 + index),
                      text: question.options[index],
                      onTap: _hasAnswered ? null : () => _select(index),
                      isSelected: _selectedIndex == index,
                      isCorrect: question.correctIndex == index,
                      showResult: _hasAnswered,
                      leadingIcon: _OptionSignIcon(index: index),
                    ),
                  );
                }),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _hasAnswered ? null : () {},
                        child: const Text('Review\nLater',
                            textAlign: TextAlign.center),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _hasAnswered || _selectedIndex == null
                            ? null
                            : _submit,
                        child: const Text('Submit\nAnswer',
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: _hasAnswered
          ? _AnswerSheet(
              isCorrect: _selectedIndex == question.correctIndex,
              explanation: _fullExplanation ?? question.shortExplanation,
              hasFullExplanation: _fullExplanation != null,
              isUnlocking: _isUnlocking,
              isContinuing: _isContinuing,
              showContinue: !_engine.hasHearts,
              isFinishing: _isFinishing,
              nextLabel: shouldFinish ? 'Finish Battle' : 'Next Question',
              onUnlock: _unlockExplanation,
              onContinue: _continueWithReward,
              onNext: _next,
            )
          : null,
    );
  }
}

class _OptionSignIcon extends StatelessWidget {
  const _OptionSignIcon({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final icon = switch (index) {
      0 => Icons.radio_button_unchecked,
      1 => Icons.remove,
      2 => Icons.priority_high,
      _ => Icons.arrow_upward,
    };
    final shape = switch (index) {
      0 => BoxShape.circle,
      1 => BoxShape.circle,
      2 => BoxShape.circle,
      _ => BoxShape.rectangle,
    };
    final fill = index == 3 ? AppColors.secondary : Colors.white;

    return Container(
      height: 58,
      width: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2.4),
      ),
      child: Center(
        child: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: fill,
            shape: shape,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Icon(
            icon,
            color: index == 3 ? Colors.white : AppColors.primary,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _AnswerSheet extends StatelessWidget {
  const _AnswerSheet({
    required this.isCorrect,
    required this.explanation,
    required this.hasFullExplanation,
    required this.isUnlocking,
    required this.isContinuing,
    required this.showContinue,
    required this.isFinishing,
    required this.nextLabel,
    required this.onUnlock,
    required this.onContinue,
    required this.onNext,
  });

  final bool isCorrect;
  final String explanation;
  final bool hasFullExplanation;
  final bool isUnlocking;
  final bool isContinuing;
  final bool showContinue;
  final bool isFinishing;
  final String nextLabel;
  final VoidCallback onUnlock;
  final VoidCallback onContinue;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                height: 6,
                width: 54,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.verified : Icons.cancel,
                  color: isCorrect ? AppColors.success : AppColors.danger,
                  size: 34,
                ),
                const SizedBox(width: 12),
                Text(
                  isCorrect ? 'Correct!' : 'Not Quite',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              explanation,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: hasFullExplanation || isUnlocking ? null : onUnlock,
              icon: isUnlocking
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                hasFullExplanation
                    ? 'Detailed Reference Unlocked'
                    : 'Unlock Detailed Reference',
              ),
            ),
            if (showContinue) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: isContinuing ? null : onContinue,
                icon: isContinuing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.favorite),
                label: const Text('Watch Ad To Restore Hearts'),
              ),
            ],
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isFinishing ? null : onNext,
              child: isFinishing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(nextLabel),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Review queue coming soon')),
              ),
              child: const Text('Review Previous'),
            ),
          ],
        ),
      ),
    );
  }
}
