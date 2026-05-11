import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const mockRows = [
      ('You', 0),
      ('Kathmandu Quizzer', 980),
      ('Pokhara Pro', 910),
      ('Dharan Champ', 860),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard', style: TextStyle(fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Placeholder leaderboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('Real leaderboard can be added later with Firebase or a backend.', style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700)),
          const SizedBox(height: 18),
          ...mockRows.indexed.map((entry) {
            final index = entry.$1;
            final row = entry.$2;
            return Card(
              child: ListTile(
                leading: CircleAvatar(backgroundColor: AppColors.primary, child: Text('${index + 1}', style: const TextStyle(color: Colors.white))),
                title: Text(row.$1, style: const TextStyle(fontWeight: FontWeight.w900)),
                trailing: Text('${row.$2}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              ),
            );
          }),
        ],
      ),
    );
  }
}
