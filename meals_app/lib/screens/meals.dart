import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/meal.dart';
import '../widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    this.category,
    required this.meals,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.onSelectMeal,
  });

  final Category? category;
  final List<Meal> meals;
  final Set<String> favoriteIds;
  final void Function(Meal meal) onToggleFavorite;
  final void Function(Meal meal) onSelectMeal;

  @override
  Widget build(BuildContext context) {
    final title = category?.title ?? 'Obľúbené jedlá';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: meals.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  category == null
                      ? 'Zatiaľ nemáš žiadne obľúbené jedlá.'
                      : 'Tejto kategórii nezodpovedajú žiadne jedlá. Skús zmeniť filtre.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            )
          : ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return MealItem(
                  meal: meal,
                  isFavorite: favoriteIds.contains(meal.id),
                  onSelectMeal: () => onSelectMeal(meal),
                );
              },
            ),
    );
  }
}
