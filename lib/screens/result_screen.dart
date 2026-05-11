import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/category_model.dart';
import '../models/quiz_result_model.dart';
import '../services/admob_service.dart';
import '../services/score_service.dart';
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
  final _adMobService = AdMobService();
  final _scoreService = ScoreService();
  bool _coinsDoubled = false;
  bool _isRewarding = false;

  Future<void> _doubleCoins() async {
    if (_isRewarding || _coinsDoubled) return;
    setState(() => _isRewarding = true);

    try {
      final rewarded = await _adMobService.showRewardedAd(placement: 'double_result_coins');
      if (rewarded) {
        await _scoreService.addCoins(widget.result.coinsEarned);
      }
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

  void _shareScore() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share placeholder: I scored ${widget.result.score} in Quiz Battle Nepal!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCoinsShown = _coinsDoubled ? widget.result.coinsEarned * 2 : widget.result.coinsEarned;

    return Scaffold(
      appBar: AppBar(title: const Text('Battle Result', style: TextStyle(fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                const Icon(Icons.emoji_events, color: AppColors.accent, size: 74),
                const SizedBox(height: 10),
                Text('${widget.result.score}', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900)),
                const Text('Final Score', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _StatTile(icon: Icons.check_circle, label: 'Correct Answers', value: '${widget.result.correctAnswers}'),
          _StatTile(icon: Icons.cancel, label: 'Wrong Answers', value: '${widget.result.wrongAnswers}'),
          _StatTile(icon: Icons.monetization_on, label: 'Coins Earned', value: '$totalCoinsShown'),
          _StatTile(icon: Icons.star, label: 'Best Score', value: '${widget.result.bestScore}'),
          const SizedBox(height: 12),
          if (!_coinsDoubled)
            OutlinedButton.icon(
              onPressed: _isRewarding ? null : _doubleCoins,
              icon: _isRewarding
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.ondemand_video),
              label: Text(_isRewarding ? 'Unlocking reward...' : 'Double coins with mock rewarded ad'),
            ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => QuizScreen(category: widget.category))),
            icon: const Icon(Icons.replay),
            label: const Text('Play Again'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => const CategoryScreen())),
            icon: const Icon(Icons.grid_view),
            label: const Text('Choose Category'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _shareScore,
            icon: const Icon(Icons.share),
            label: const Text('Share Score'),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        trailing: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      ),
    );
  }
}
