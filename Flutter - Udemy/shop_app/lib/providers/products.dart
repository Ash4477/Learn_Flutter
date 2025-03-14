import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  final String? authToken;
  final String? userId;

  List<Product> _items;

  Products(this._items, {this.authToken, this.userId});

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((item) => id == item.id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    var url = Uri.https(
      'flutter-udemy-36113-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/products.json',
      {
        'auth': authToken,
        if (filterByUser) 'orderBy': '"creatorId"',
        if (filterByUser) 'equalTo': '"$userId"',
      },
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }

      url = Uri.https(
        'flutter-udemy-36113-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/userFavourites/$userId.json',
        {
          'auth': authToken,
        },
      );
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavourite: favData == null ? false : favData[prodId] ?? false,
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https(
      'flutter-udemy-36113-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/products.json',
      {
        'auth': authToken,
      },
    );
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https(
        'flutter-udemy-36113-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products/$id.json',
        {
          'auth': authToken,
        },
      );
      try {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
            }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    } else {
      // print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https(
      'flutter-udemy-36113-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/products/$id.json',
      {
        'auth': authToken,
      },
    );
    final existingProductIdx = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIdx];

    _items.removeAt(existingProductIdx);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIdx, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
