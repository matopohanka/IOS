import 'package:flutter/material.dart';
import '../models/meal.dart';
import 'meal_item_trait.dart';

class MealItem extends StatelessWidget {
  const MealItem({
    super.key,
    required this.meal,
    required this.isFavorite,
    required this.onSelectMeal,
  });

  final Meal meal;
  final bool isFavorite;
  final void Function() onSelectMeal;

  String get complexityText {
    switch (meal.complexity) {
      case Complexity.simple: return 'Jednoduchá';
      case Complexity.challenging: return 'Stredná';
      case Complexity.hard: return 'Náročná';
    }
  }

  String get affordabilityText {
    switch (meal.affordability) {
      case Affordability.affordable: return 'Lacné';
      case Affordability.pricey: return 'Stredná cena';
      case Affordability.luxurious: return 'Drahšie';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onSelectMeal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.network(
                  meal.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.black12,
                    child: const Icon(Icons.restaurant, size: 64),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.redAccent : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(meal.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      MealItemTrait(icon: Icons.schedule, label: '${meal.duration} min'),
                      MealItemTrait(icon: Icons.work, label: complexityText),
                      MealItemTrait(icon: Icons.euro, label: affordabilityText),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
