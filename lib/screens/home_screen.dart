import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../data/category_catalog.dart';
import '../widgets/banner_ad_placeholder.dart';
import '../widgets/category_card.dart';
import 'category_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dailyCategory = CategoryCatalog.dailyCategory(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName, style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            tooltip: 'Leaderboard',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const LeaderboardScreen())),
            icon: const Icon(Icons.leaderboard),
          ),
          IconButton(
            tooltip: 'Profile',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ProfileScreen())),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.secondary, AppColors.primary]),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Namaste, Challenger 👋', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('Win coins, protect hearts, and master Nepal-focused MCQs.', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: AppColors.text),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => QuizScreen(category: dailyCategory))),
                  icon: const Icon(Icons.local_fire_department),
                  label: const Text('Play Daily Quiz'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const BannerAdPlaceholder(),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(child: Text('Battle Categories', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900))),
              TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const CategoryScreen())),
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...CategoryCatalog.all.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: CategoryCard(
                category: category,
                onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => QuizScreen(category: category))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
