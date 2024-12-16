import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';
import 'providers/products.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.deepOrange,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
        },
      ),
    );
  }
}
