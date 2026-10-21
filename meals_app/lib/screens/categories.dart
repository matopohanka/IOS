
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/category.dart';
import '../widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({
    super.key,
    required this.onSelectCategory,
  });

  final void Function(Category category) onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final category in availableCategories)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              height: 75,
              child: CategoryGridItem(
                category: category,
                onSelectCategory: () => onSelectCategory(category),
              ),
            ),
          ),
      ],
    );
  }
}
