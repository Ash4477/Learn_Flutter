import 'package:flutter/material.dart';

import 'dummy_data.dart';
import 'models/meal.dart';
import 'screens/filters_screen.dart';
import 'screens/tabs_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'screens/category_meals_screen.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegetarian': false,
    'vegan': false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  final List<Meal> _favouritedMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten']! && !meal.isGlutenFree) {
          return false;
        } else if (_filters['lactose']! && !meal.isLactoseFree) {
          return false;
        } else if (_filters['vegan']! && !meal.isVegan) {
          return false;
        } else if (_filters['vegetarian']! && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavourites(String mealId) {
    final existingIndex =
        _favouritedMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) {
      setState(() {
        _favouritedMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favouritedMeals.add(
          DUMMY_MEALS.firstWhere((meal) => mealId == meal.id),
        );
      });
    }
  }

  bool _isMealFavourite(String id) {
    return _favouritedMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primaryColor: Colors.pink,
        primarySwatch: Colors.pink,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amber),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 242, 202),
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyMedium: const TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
              bodyLarge: const TextStyle(color: Colors.white, fontSize: 20),
              titleMedium: const TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
            ),
        tabBarTheme: const TabBarTheme(
          labelStyle: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.pink,
        ),
      ),
      initialRoute: '/', // default is / , only use if different
      routes: {
        '/': (ctx) => TabsScreen(_favouritedMeals),
        CategoryMealsScreen.routeName: (ctx) =>
            CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName: (ctx) =>
            MealDetailScreen(_toggleFavourites, _isMealFavourite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters, _setFilters),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => const CategoriesScreen());
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => const CategoriesScreen());
      },
    );
  }
}
