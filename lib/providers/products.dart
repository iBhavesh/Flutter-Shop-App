import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

const _firebase = 'https://flutter-shop-app-6ecaa.firebaseio.com/products.json';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(_firebase,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'isFavourite': product.isFavourite,
            'imageUrl': product.imageUrl,
          }));
      _items.add(Product(
        description: product.description,
        title: product.title,
        imageUrl: product.imageUrl,
        price: product.price,
        id: json.decode(response.body)['name'],
      ));
      notifyListeners();
    } catch (error) {
      debugPrint('$error');
      throw error;
    }
  }

  Future<void> uploadData() async {
    try {
      await Future.forEach(_items, (product) async {
        // debugPrint('ForEach Start: ${DateTime.now().toString()}');
        final response = await http.post(
          _firebase,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'isFavourite': product.isFavourite,
            'imageUrl': product.imageUrl,
          }),
        );
        // debugPrint('${DateTime.now().toString()}');
        debugPrint('${json.decode(response.body)}');
      });
    } catch (error) {
      debugPrint(error.toString());
      throw (error);
    }
  }

  void updateProduct(Product product) {
    final productIndex =
        _items.indexWhere((element) => element.id == product.id);
    if (productIndex >= 0) {
      _items[productIndex] = product;
    }
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
