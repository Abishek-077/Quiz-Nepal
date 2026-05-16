import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/app_chrome.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const rows = [
      _RankRow(
          rank: 4,
          name: 'Binita Thapa',
          level: 'Level 42 - Aspirant',
          xp: 10920),
      _RankRow(
          rank: 5, name: 'Sabin Gurung', level: 'Level 39 - Scholar', xp: 9450),
      _RankRow(
          rank: 6,
          name: 'Nikita Joshi',
          level: 'Level 35 - Contender',
          xp: 8200),
      _RankRow(
          rank: 7, name: 'Kiran Rai', level: 'Level 31 - Challenger', xp: 7600),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const BattleHeader(),
          Expanded(
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.fromLTRB(22, 28, 22, 132),
                  children: [
                    const _LeaderboardToggle(),
                    const SizedBox(height: 36),
                    const _Podium(),
                    const SizedBox(height: 42),
                    const Text(
                      'TOP RANKERS',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...rows.map((row) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: row,
                        )),
                  ],
                ),
                const Positioned(
                  left: 22,
                  right: 22,
                  bottom: 16,
                  child: _YourRankCard(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BattleBottomNav(current: BattleTab.rankings),
    );
  }
}

class _LeaderboardToggle extends StatelessWidget {
  const _LeaderboardToggle();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.blush,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'Weekly',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(
              height: 42,
              child: Center(
                child: Text(
                  'All-Time',
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const Positioned(
            top: 0,
            child: _WinnerBlock(),
          ),
          const Positioned(
            left: 20,
            bottom: 18,
            child: _SideWinner(
              rank: 2,
              name: 'Aayush M.',
              xp: '12,450 XP',
              color: Color(0xFFB8C0C2),
            ),
          ),
          const Positioned(
            right: 18,
            bottom: 8,
            child: _SideWinner(
              rank: 3,
              name: 'Rohan K.',
              xp: '11,800 XP',
              color: Color(0xFFD8842D),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 112,
              height: 122,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: const Icon(Icons.emoji_events, color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _WinnerBlock extends StatelessWidget {
  const _WinnerBlock();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 57,
              backgroundColor: AppColors.accent,
              child: BattleAvatar(radius: 50),
            ),
            Positioned(
              right: -6,
              bottom: 4,
              child: _RankBadge(rank: 1, color: AppColors.accent),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          'Priya Sharma',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          '14,200 XP',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _SideWinner extends StatelessWidget {
  const _SideWinner({
    required this.rank,
    required this.name,
    required this.xp,
    required this.color,
  });

  final int rank;
  final String name;
  final String xp;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: color,
                child: const BattleAvatar(radius: 30),
              ),
              Positioned(
                right: -8,
                bottom: 0,
                child: _RankBadge(rank: rank, color: color),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            xp,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank, required this.color});

  final int rank;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: color,
      child: Text(
        '$rank',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.rank,
    required this.name,
    required this.level,
    required this.xp,
  });

  final int rank;
  final String name;
  final String level;
  final int xp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              '$rank',
              style: const TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
          const BattleAvatar(radius: 25),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  level,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${_formatXp(xp)}\nXP',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  String _formatXp(int xp) {
    final text = xp.toString();
    if (text.length <= 3) return text;
    return '${text.substring(0, text.length - 3)},${text.substring(text.length - 3)}';
  }
}

class _YourRankCard extends StatelessWidget {
  const _YourRankCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF43292B),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Row(
        children: [
          Text(
            '#45',
            style: TextStyle(
              color: Color(0xFFFFB1B1),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(width: 16),
          BattleAvatar(radius: 24),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You (Bishal R.)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "Keep going! You're in the top 10%",
                  style: TextStyle(
                    color: Color(0xFFE8C9C9),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '2,450\nXP',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color(0xFFFFB1B1),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
