import 'package:flutter/material.dart';

import '../data/category_catalog.dart';
import '../widgets/banner_ad_placeholder.dart';
import '../widgets/category_card.dart';
import 'quiz_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Choose Category',
              style: TextStyle(fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const BannerAdPlaceholder(),
          const SizedBox(height: 18),
          ...CategoryCatalog.all.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: CategoryCard(
                category: category,
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                        builder: (_) => QuizScreen(category: category))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
