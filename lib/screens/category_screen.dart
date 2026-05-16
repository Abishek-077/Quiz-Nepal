import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../data/category_catalog.dart';
import '../widgets/app_chrome.dart';
import '../widgets/category_card.dart';
import 'quiz_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const BattleHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              children: [
                const Text(
                  'Choose Your Exam Category',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Select a specialized field to begin your high-stakes preparation battle.',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                ...CategoryCatalog.all.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CategoryCard(
                      category: category,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => QuizScreen(category: category),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const _WeeklyBattleCard(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BattleBottomNav(current: BattleTab.categories),
    );
  }
}

class _WeeklyBattleCard extends StatelessWidget {
  const _WeeklyBattleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -14,
            bottom: -20,
            child: Icon(
              Icons.emoji_events,
              color: Color(0x33FFFFFF),
              size: 96,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Weekly Battle Royale',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join the nationwide competition this Saturday!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(44),
                  ),
                  onPressed: () {},
                  child: const Text('Register Now'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
