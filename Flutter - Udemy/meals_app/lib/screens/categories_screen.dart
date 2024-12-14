import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../widgets/category_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DeliMeals',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.pink,
      ),
      body: GridView(
        padding: const EdgeInsets.all(25),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: <Widget>[
          ...DUMMY_CATEGORIES.map((category) {
            return CategoryItem(category.id, category.title, category.color);
          })
        ],
      ),
    );
  }
}
