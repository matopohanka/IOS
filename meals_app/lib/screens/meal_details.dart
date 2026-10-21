import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final Meal meal;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  Widget sectionTitle(BuildContext context, String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
    )),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meal.title)),
      floatingActionButton: FloatingActionButton(
        onPressed: onToggleFavorite,
        tooltip: isFavorite ? 'Odobrať z obľúbených' : 'Pridať do obľúbených',
        child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      ),
      body: ListView(
        children: [
          Image.network(
            meal.imageUrl,
            height: 280,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 220,
              color: Colors.black12,
              child: const Icon(Icons.restaurant, size: 72),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle(context, 'Ingrediencie'),
                for (final ingredient in meal.ingredients)
                  Card(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 7),
                          const SizedBox(width: 10),
                          Expanded(child: Text(ingredient)),
                        ],
                      ),
                    ),
                  ),
                sectionTitle(context, 'Postup prípravy'),
                for (var i = 0; i < meal.steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          child: Text('${i + 1}'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(meal.steps[i]),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
