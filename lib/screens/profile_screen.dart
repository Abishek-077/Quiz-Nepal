import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/di/app_dependencies.dart';
import '../features/quiz/domain/entities/user_stats.dart';
import '../widgets/app_chrome.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final getUserStats = AppScope.of(context).getUserStats;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const BattleHeader(showBack: true),
          Expanded(
            child: FutureBuilder<UserStats>(
              future: getUserStats(),
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
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  );
                }

                final stats = snapshot.data ?? const UserStats.empty();
                final accuracy = stats.quizzesPlayed == 0
                    ? 88
                    : ((stats.correctAnswers / (stats.quizzesPlayed * 10)) *
                            100)
                        .clamp(0, 100)
                        .round();

                return ListView(
                  padding: const EdgeInsets.fromLTRB(22, 36, 22, 24),
                  children: [
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const CircleAvatar(
                            radius: 64,
                            backgroundColor: AppColors.primary,
                            child: BattleAvatar(radius: 58),
                          ),
                          Positioned(
                            right: -2,
                            bottom: 6,
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Aadesh Kumar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'ELITE LEARNER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 17,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 42),
                    Row(
                      children: [
                        Expanded(
                          child: _ProfileStat(
                            label: 'Total\nQuizzes',
                            value: stats.quizzesPlayed == 0
                                ? '250'
                                : '${stats.quizzesPlayed}',
                            icon: Icons.quiz_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ProfileStat(
                            label: 'Accuracy',
                            value: '$accuracy%',
                            icon: Icons.ads_click,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: _ProfileStat(
                            label: 'Rank',
                            value: '#45',
                            icon: Icons.emoji_events_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 38),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Achievements',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 27,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _Achievement(
                          icon: Icons.flash_on,
                          label: '10 Day Streak',
                        ),
                        _Achievement(
                          icon: Icons.school,
                          label: 'Loksewa Pro',
                        ),
                        _Achievement(
                          icon: Icons.directions_car,
                          label: 'Road King',
                        ),
                      ],
                    ),
                    const SizedBox(height: 38),
                    const Text(
                      'Category Mastery',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const _MasteryRow(
                      icon: Icons.traffic,
                      label: 'Driving License',
                      value: 0.92,
                    ),
                    const SizedBox(height: 24),
                    const _MasteryRow(
                      icon: Icons.public,
                      label: 'General Knowledge',
                      value: 0.75,
                    ),
                    const SizedBox(height: 24),
                    _MasteryRow(
                      icon: Icons.monetization_on,
                      label: 'Coins Collected',
                      value: (stats.totalCoins / 1000).clamp(0, 1).toDouble(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BattleBottomNav(current: BattleTab.home),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 126),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.secondary),
          const SizedBox(height: 10),
          FittedBox(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _Achievement extends StatelessWidget {
  const _Achievement({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      child: Column(
        children: [
          Container(
            height: 92,
            width: 92,
            decoration: BoxDecoration(
              color: AppColors.blush,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFA9A9), width: 2),
            ),
            child: Icon(icon, color: AppColors.primary, size: 40),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MasteryRow extends StatelessWidget {
  const _MasteryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final percent = (value * 100).round();
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.secondary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Text(
              '$percent%',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 12,
            color: AppColors.primary,
            backgroundColor: AppColors.blush,
          ),
        ),
      ],
    );
  }
}
