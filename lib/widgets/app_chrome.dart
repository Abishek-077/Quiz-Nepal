import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../screens/category_screen.dart';
import '../screens/home_screen.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/study_resources_screen.dart';

enum BattleTab { home, categories, resources, rankings }

class BattleHeader extends StatelessWidget {
  const BattleHeader({
    this.compact = false,
    this.showBack = false,
    this.score = 150,
    this.hearts = 5,
    super.key,
  });

  final bool compact;
  final bool showBack;
  final int score;
  final int hearts;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.fromLTRB(16, compact ? 10 : 12, 16, 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (showBack) ...[
              IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              const SizedBox(width: 2),
            ] else
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ProfileScreen(),
                  ),
                ),
                child: const BattleAvatar(radius: 20),
              ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                AppStrings.appName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 10),
            BattleWallet(score: score, hearts: hearts),
          ],
        ),
      ),
    );
  }
}

class BattleAvatar extends StatelessWidget {
  const BattleAvatar({this.radius = 24, super.key});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary,
      child: CircleAvatar(
        radius: radius - 2,
        backgroundColor: const Color(0xFFFFE8D9),
        child: Icon(
          Icons.person,
          color: AppColors.text,
          size: radius * 1.15,
        ),
      ),
    );
  }
}

class BattleWallet extends StatelessWidget {
  const BattleWallet({
    required this.score,
    required this.hearts,
    super.key,
  });

  final int score;
  final int hearts;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 108, maxWidth: 128),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.blush,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$score',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.monetization_on, color: Color(0xFFE0A019), size: 16),
          const SizedBox(width: 8),
          Container(width: 1, height: 17, color: AppColors.border),
          const SizedBox(width: 8),
          Text(
            '$hearts',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.favorite, color: AppColors.primary, size: 16),
        ],
      ),
    );
  }
}

class BattleBottomNav extends StatelessWidget {
  const BattleBottomNav({required this.current, super.key});

  final BattleTab current;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.border),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: AppColors.text.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            _BattleNavItem(
              tab: BattleTab.home,
              current: current,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'Home',
            ),
            _BattleNavItem(
              tab: BattleTab.categories,
              current: current,
              icon: Icons.grid_view_outlined,
              selectedIcon: Icons.grid_view,
              label: 'Categories',
            ),
            _BattleNavItem(
              tab: BattleTab.resources,
              current: current,
              icon: Icons.menu_book_outlined,
              selectedIcon: Icons.menu_book,
              label: 'Resources',
            ),
            _BattleNavItem(
              tab: BattleTab.rankings,
              current: current,
              icon: Icons.bar_chart_outlined,
              selectedIcon: Icons.bar_chart,
              label: 'Rankings',
            ),
          ],
        ),
      ),
    );
  }
}

class _BattleNavItem extends StatelessWidget {
  const _BattleNavItem({
    required this.tab,
    required this.current,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final BattleTab tab;
  final BattleTab current;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final selected = tab == current;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: selected ? null : () => _goToTab(context, tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 48,
          decoration: BoxDecoration(
            color: selected ? AppColors.navBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? selectedIcon : icon,
                color: selected ? AppColors.secondary : AppColors.muted,
                size: 21,
              ),
              const SizedBox(height: 2),
              FittedBox(
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected ? AppColors.secondary : AppColors.text,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToTab(BuildContext context, BattleTab tab) {
    final page = switch (tab) {
      BattleTab.home => const HomeScreen(),
      BattleTab.categories => const CategoryScreen(),
      BattleTab.resources => const StudyResourcesScreen(),
      BattleTab.rankings => const LeaderboardScreen(),
    };

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => page),
      (route) => false,
    );
  }
}
