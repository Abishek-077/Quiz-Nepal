import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../services/storage_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Stats', style: TextStyle(fontWeight: FontWeight.w900))),
      body: FutureBuilder<List<int>>(
        future: Future.wait([
          storage.totalCoins,
          storage.bestScore,
          storage.quizzesPlayed,
          storage.correctAnswers,
          storage.currentStreak,
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load local stats. ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w800),
                ),
              ),
            );
          }

          final values = snapshot.data ?? [0, 0, 0, 0, 0];
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const CircleAvatar(radius: 42, backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white, size: 44)),
              const SizedBox(height: 14),
              const Center(child: Text('Guest Challenger', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900))),
              const Center(child: Text('Login-free MVP profile', style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700))),
              const SizedBox(height: 20),
              _ProfileStat(label: 'Total Coins', value: values[0], icon: Icons.monetization_on),
              _ProfileStat(label: 'Best Score', value: values[1], icon: Icons.star),
              _ProfileStat(label: 'Quizzes Played', value: values[2], icon: Icons.sports_esports),
              _ProfileStat(label: 'Correct Answers', value: values[3], icon: Icons.check_circle),
              _ProfileStat(label: 'Current Streak Placeholder', value: values[4], icon: Icons.local_fire_department),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value, required this.icon});

  final String label;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        trailing: Text('$value', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 19)),
      ),
    );
  }
}
