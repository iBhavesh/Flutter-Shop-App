import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

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
    const _firebase =
        'https://flutter-shop-app-6ecaa.firebaseio.com/products.json';
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

  Future<void> fetchAndSetProducts() async {
    const _firebase =
        'https://flutter-shop-app-6ecaa.firebaseio.com/products.json';
    _items.clear();
    try {
      final response = await http.get(_firebase);
      if (json.decode(response.body) != null) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        extractedData.forEach((productId, productData) {
          _items.add(Product(
            description: productData['description'],
            id: productId,
            imageUrl: productData['imageUrl'],
            price: productData['price'],
            title: productData['title'],
            isFavourite: productData['isFavourite'],
          ));
        });
      }
    } catch (error) {
      debugPrint(error.toString());
      throw (error);
    }
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final _firebase =
        'https://flutter-shop-app-6ecaa.firebaseio.com/products/${product.id}.json';
    final productIndex =
        _items.indexWhere((element) => element.id == product.id);
    if (productIndex >= 0) {
      _items[productIndex] = product;
    }
    try {
      await http.patch(_firebase,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
    } catch (error) {
      debugPrint(error.toString());
      throw (error);
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final _firebase =
        'https://flutter-shop-app-6ecaa.firebaseio.com/products/$id.json';
    try {
      final response = await http.delete(_firebase);
      if (response.statusCode == 200)
        _items.removeWhere((element) => element.id == id);
      else
        throw HttpException('Could not delete product');
    } catch (error) {
      debugPrint(error.toString());
      throw (error);
    }
    notifyListeners();
  }
}
