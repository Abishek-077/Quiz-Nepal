import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/di/app_dependencies.dart';
import '../features/quiz/domain/entities/quiz_category.dart';
import '../features/quiz/domain/entities/quiz_result.dart';
import '../features/quiz/domain/usecases/double_coins_with_reward.dart';
import '../widgets/app_chrome.dart';
import 'category_screen.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({required this.result, required this.category, super.key});

  final QuizResult result;
  final QuizCategory category;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late DoubleCoinsWithReward _doubleCoinsWithReward;
  bool _hasLoadedDependencies = false;
  bool _coinsDoubled = false;
  bool _isRewarding = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoadedDependencies) return;
    final dependencies = AppScope.of(context);
    _doubleCoinsWithReward = dependencies.doubleCoinsWithReward;
    _hasLoadedDependencies = true;
  }

  Future<void> _doubleCoins() async {
    if (_isRewarding || _coinsDoubled) return;
    setState(() => _isRewarding = true);

    try {
      final rewarded = await _doubleCoinsWithReward(widget.result.coinsEarned);
      if (!mounted) return;
      setState(() {
        _coinsDoubled = rewarded;
        _isRewarding = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _isRewarding = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not double coins yet: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.result.correctAnswers + widget.result.wrongAnswers;
    final accuracy =
        total == 0 ? 0 : ((widget.result.correctAnswers / total) * 100).round();
    final totalCoinsShown = _coinsDoubled
        ? widget.result.coinsEarned * 2
        : widget.result.coinsEarned;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const BattleHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 42, 22, 24),
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundColor: Color(0xFFFFFAC7),
                  child: Icon(
                    Icons.emoji_events,
                    color: Color(0xFFD08B00),
                    size: 52,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Battle Complete!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Exceptional performance, Candidate!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 42),
                Center(
                  child: _ScoreRing(
                    correct: widget.result.correctAnswers,
                    total: total,
                  ),
                ),
                const SizedBox(height: 42),
                _ResultStatCard(
                  icon: Icons.flash_on,
                  label: 'Accuracy',
                  value: '$accuracy%',
                ),
                const SizedBox(height: 16),
                _ResultStatCard(
                  icon: Icons.monetization_on,
                  label: 'Coins Earned',
                  value: '+$totalCoinsShown',
                ),
                const SizedBox(height: 16),
                _ResultStatCard(
                  icon: Icons.star,
                  label: 'Best Score',
                  value: '${widget.result.bestScore}',
                ),
                const SizedBox(height: 18),
                if (!_coinsDoubled)
                  OutlinedButton.icon(
                    onPressed: _isRewarding ? null : _doubleCoins,
                    icon: _isRewarding
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.ondemand_video),
                    label: Text(
                      _isRewarding ? 'Unlocking reward...' : 'Double Coins',
                    ),
                  ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => QuizScreen(category: widget.category),
                    ),
                  ),
                  icon: const Icon(Icons.replay),
                  label: const Text('Play Again'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => const CategoryScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.grid_view),
                  label: const Text('Choose Category'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BattleBottomNav(current: BattleTab.home),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.correct, required this.total});

  final int correct;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : correct / total;
    return SizedBox(
      height: 220,
      width: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const CircularProgressIndicator(
            value: 1,
            strokeWidth: 26,
            color: Color(0xFFE5E7EB),
            backgroundColor: Colors.transparent,
          ),
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 26,
            strokeCap: StrokeCap.butt,
            color: const Color(0xFF0648AA),
            backgroundColor: Colors.transparent,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$correct/$total',
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 42,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Text(
                  'CORRECT ANSWERS',
                  style: TextStyle(
                    color: AppColors.muted,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultStatCard extends StatelessWidget {
  const _ResultStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.secondary, size: 27),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
