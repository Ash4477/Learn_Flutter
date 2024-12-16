import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

enum FilterOptions {
  // ignore: constant_identifier_names
  Favourites,
  // ignore: constant_identifier_names
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favourites) {
                    _showOnlyFavourites = true;
                  } else {
                    _showOnlyFavourites = false;
                  }
                });
              },
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: FilterOptions.Favourites,
                      child: Text('Only Favourites'),
                    ),
                    PopupMenuItem(
                      value: FilterOptions.All,
                      child: Text('Show All'),
                    ),
                  ]),
        ],
      ),
      body: ProductsGrid(_showOnlyFavourites),
    );
  }
}
