import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/category_model.dart';
import '../models/question_model.dart';
import '../services/admob_service.dart';
import '../services/explanation_service.dart';
import '../services/question_service.dart';
import '../services/quiz_engine.dart';
import '../services/score_service.dart';
import '../widgets/explanation_card.dart';
import '../widgets/quiz_option_button.dart';
import '../widgets/score_header.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({required this.category, super.key});

  final QuizCategory category;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _questionService = QuestionService();
  final _scoreService = ScoreService();
  final _adMobService = AdMobService();
  final _explanationService = ExplanationService();
  final _engine = QuizEngine();

  List<Question> _questions = [];
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _isLoading = true;
  bool _isUnlocking = false;
  bool _isContinuing = false;
  bool _isFinishing = false;
  String? _loadError;
  String? _fullExplanation;

  Question get _currentQuestion => _questions[_currentIndex];
  bool get _hasAnswered => _selectedIndex != null;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
      _questions = [];
      _currentIndex = 0;
      _selectedIndex = null;
      _fullExplanation = null;
      _engine.start();
    });

    try {
      final questions = await _questionService.randomQuiz(widget.category);
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

  void _answer(int index) {
    if (_hasAnswered || !_engine.hasHearts || _isFinishing) return;
    setState(() {
      _selectedIndex = index;
      _engine.answer(selectedIndex: index, correctIndex: _currentQuestion.correctIndex);
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
      _fullExplanation = null;
      _isUnlocking = false;
    });
  }

  Future<void> _finishQuiz() async {
    if (_isFinishing) return;
    setState(() => _isFinishing = true);

    try {
      await _adMobService.showInterstitialAd();
      final result = await _scoreService.completeQuiz(
        categoryId: widget.category.id,
        score: _engine.score,
        correctAnswers: _engine.correctAnswers,
        wrongAnswers: _engine.wrongAnswers,
        coinsEarned: _engine.coinsEarned,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => ResultScreen(result: result, category: widget.category)),
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
    final explanation = await _explanationService.unlockFullExplanation(_currentQuestion);
    if (!mounted) return;
    setState(() {
      _fullExplanation = explanation;
      _isUnlocking = false;
    });
  }

  Future<void> _continueWithReward() async {
    if (_isContinuing || _engine.hasHearts) return;
    setState(() => _isContinuing = true);
    final rewarded = await _adMobService.showRewardedAd(placement: 'continue_after_hearts');
    if (!mounted) return;
    setState(() {
      if (rewarded) {
        _engine.restoreHearts(QuizEngine.rewardedContinueHearts);
      }
      _isContinuing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.category.title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null || _questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.category.title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppColors.danger, size: 54),
                const SizedBox(height: 14),
                const Text('Could not start this quiz', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(
                  _loadError ?? 'No questions found for this category.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700),
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
      );
    }

    final progress = (_currentIndex + 1) / _questions.length;
    final question = _currentQuestion;
    final selectedIsWrong = _selectedIndex != null && _selectedIndex != question.correctIndex;
    final shouldFinish = _currentIndex == _questions.length - 1 || !_engine.hasHearts;

    return Scaffold(
      appBar: AppBar(title: Text(widget.category.title, style: const TextStyle(fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          ScoreHeader(score: _engine.score, hearts: _engine.hearts, coins: _engine.coinsEarned),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              color: AppColors.primary,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            ),
          ),
          const SizedBox(height: 18),
          Text('Question ${_currentIndex + 1}/${_questions.length}', style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(question.question, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, height: 1.25)),
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(question.options.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: QuizOptionButton(
                label: String.fromCharCode(65 + index),
                text: question.options[index],
                onTap: _hasAnswered ? null : () => _answer(index),
                isSelected: _selectedIndex == index,
                isCorrect: question.correctIndex == index,
                showResult: _hasAnswered,
              ),
            );
          }),
          if (selectedIsWrong) ...[
            const SizedBox(height: 8),
            ExplanationCard(
              shortExplanation: question.shortExplanation,
              fullExplanation: _fullExplanation,
              isUnlocking: _isUnlocking,
              onUnlock: _unlockExplanation,
            ),
          ],
          if (_hasAnswered) ...[
            const SizedBox(height: 16),
            if (!_engine.hasHearts)
              OutlinedButton.icon(
                onPressed: _isContinuing ? null : _continueWithReward,
                icon: _isContinuing
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.favorite),
                label: const Text('Watch mock rewarded ad to continue'),
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isFinishing ? null : _next,
              child: _isFinishing
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(shouldFinish ? 'Finish Quiz' : 'Next Question'),
            ),
          ],
        ],
      ),
    );
  }
}
