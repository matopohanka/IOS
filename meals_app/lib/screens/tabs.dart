import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/dummy_data.dart';
import '../models/category.dart';
import '../models/meal.dart';
import 'categories.dart';
import 'filters.dart';
import 'meal_details.dart';
import 'meals.dart';

const _filterKeys = ['gluten', 'lactose', 'vegan', 'vegetarian'];

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final Set<String> _favoriteIds = {};
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _favoriteIds
        ..clear()
        ..addAll(prefs.getStringList('favoriteMealIds') ?? []);
      for (final key in _filterKeys) {
        _filters[key] = prefs.getBool('filter_$key') ?? false;
      }
      _isLoading = false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteMealIds', _favoriteIds.toList());
    for (final key in _filterKeys) {
      await prefs.setBool('filter_$key', _filters[key] ?? false);
    }
  }

  void _toggleFavorite(Meal meal) {
    setState(() {
      if (!_favoriteIds.add(meal.id)) {
        _favoriteIds.remove(meal.id);
      }
    });
    _savePreferences();
  }

  bool _matchesFilters(Meal meal) {
    if (_filters['gluten']! && !meal.isGlutenFree) return false;
    if (_filters['lactose']! && !meal.isLactoseFree) return false;
    if (_filters['vegan']! && !meal.isVegan) return false;
    if (_filters['vegetarian']! && !meal.isVegetarian) return false;
    return true;
  }

  List<Meal> get _availableMeals =>
      dummyMeals.where(_matchesFilters).toList();

  void _selectCategory(Category category) {
    final categoryMeals = _availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (ctx) => MealsScreen(
          category: category,
          meals: categoryMeals,
          favoriteIds: _favoriteIds,
          onToggleFavorite: _toggleFavorite,
          onSelectMeal: _selectMeal,
        ),
      ),
    );
  }

  void _selectMeal(Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (ctx) => MealDetailsScreen(
          meal: meal,
          isFavorite: _favoriteIds.contains(meal.id),
          onToggleFavorite: () => _toggleFavorite(meal),
        ),
      ),
    );
  }

  Future<void> _openFilters() async {
    final result = await Navigator.of(context).push<Map<String, bool>>(
      MaterialPageRoute(
        builder: (ctx) => FiltersScreen(currentFilters: _filters),
      ),
    );
    if (result == null || !mounted) return;
    setState(() => _filters = Map<String, bool>.from(result));
    await _savePreferences();
  }

  void _selectPage(int index) {
    setState(() => _selectedPageIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      CategoriesScreen(onSelectCategory: _selectCategory),
      MealsScreen(
        meals: _availableMeals
            .where((meal) => _favoriteIds.contains(meal.id))
            .toList(),
        favoriteIds: _favoriteIds,
        onToggleFavorite: _toggleFavorite,
        onSelectMeal: _selectMeal,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedPageIndex == 0 ? 'Vyber si kategóriu' : 'Obľúbené jedlá'),
        actions: [
          IconButton(
            onPressed: _openFilters,
            tooltip: 'Filtre',
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(index: _selectedPageIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedPageIndex,
        onDestinationSelected: _selectPage,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Kategórie'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Obľúbené'),
        ],
      ),
    );
  }
}
