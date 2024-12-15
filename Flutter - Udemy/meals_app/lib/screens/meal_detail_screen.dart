import 'package:flutter/material.dart';

import '../widgets/custom_appbar.dart';
import '../dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';
  final Function toggleFavourites;
  final Function isMealFavourite;
  const MealDetailScreen(
    this.toggleFavourites,
    this.isMealFavourite, {
    super.key,
  });

  Widget _buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 200,
      width: 300,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context)?.settings.arguments as String;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => mealId == meal.id);

    return Scaffold(
      appBar: customAppBar(context, selectedMeal.title),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(selectedMeal.imageUrl, fit: BoxFit.cover),
            ),
            _buildSectionTitle(context, 'Ingredients'),
            _buildContainer(ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(selectedMeal.ingredients[index]),
                  ),
                );
              },
              itemCount: selectedMeal.ingredients.length,
            )),
            _buildSectionTitle(context, 'Steps'),
            _buildContainer(ListView.builder(
              itemBuilder: (ctx, index) => Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        '# ${(index + 1)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    title: Text(
                      selectedMeal.steps[index],
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                ],
              ),
              itemCount: selectedMeal.steps.length,
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.black,
        onPressed: () => toggleFavourites(mealId),
        child: isMealFavourite(mealId)
            ? const Icon(Icons.star)
            : const Icon(Icons.star_border),
      ),
    );
  }
}
