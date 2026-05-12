import 'package:flutter/material.dart';

import 'coins_widget.dart';
import 'hearts_widget.dart';

class ScoreHeader extends StatelessWidget {
  const ScoreHeader(
      {required this.score,
      required this.hearts,
      required this.coins,
      super.key});

  final int score;
  final int hearts;
  final int coins;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceBetween,
      children: [
        Text('Score $score',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        HeartsWidget(hearts: hearts),
        CoinsWidget(coins: coins),
      ],
    );
  }
}
