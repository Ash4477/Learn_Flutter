import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/main_drawer.dart';
import './categories_screen.dart';
import './favourites_screen.dart';

class TabsScreen extends StatefulWidget {
  final List<Meal> favouriteMeals;
  const TabsScreen(this.favouriteMeals, {super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {'page': const CategoriesScreen(), 'title': 'Categories'},
      {
        'page': FavouritesScreen(widget.favouriteMeals),
        'title': 'Your Favourites'
      }
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pages[_selectedPageIndex]['title'] as String,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      drawer: const MainDrawer(),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.star),
            label: 'Favourites',
          ),
        ],
      ),
    );
  }
}


// FOR TOP APPBAR 
//  @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'DeliMeals',
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//           bottom: TabBar(
//               indicatorColor: Theme.of(context).colorScheme.secondary,
//               tabs: const <Widget>[
//                 Tab(
//                   icon: Icon(Icons.category),
//                   text: 'Categories',
//                 ),
//                 Tab(
//                   icon: Icon(Icons.star),
//                   text: 'Favourites',
//                 ),
//               ]),
//         ),
//         body: const TabBarView(children: <Widget>[
//           CategoriesScreen(),
//           FavouritesScreen(),
//         ]),
//       ),
//     );
//   }