import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  final String authToken, userId;
  List<Product> _items = [];
  Products(this.authToken, this.userId, this._items);

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
    final _firebase =
        'https://flutter-shop-app-6ecaa.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(_firebase,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'isFavourite': product.isFavourite,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));
      _items.add(Product(
        description: product.description,
        title: product.title,
        imageUrl: product.imageUrl,
        price: product.price,
        id: json.decode(response.body)['name'],
      ));
      notifyListeners();
    } on SocketException catch (error) {
      debugPrint(error.toString());
      throw HttpException('No Internet! Please check your network connection.');
    } catch (error) {
      debugPrint('$error');
      throw error;
    }
  }

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    final queryParameters = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"': '';
    var url =
        'https://flutter-shop-app-6ecaa.firebaseio.com/products.json?auth=$authToken&$queryParameters';
    _items.clear();
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      if (extractedData['error'] != null) {
        throw HttpException(extractedData['error']);
      }
      if (extractedData != null) {
        url =
            'https://flutter-shop-app-6ecaa.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
        final favourites = await http.get(url);
        final extractedFav = json.decode(favourites.body);
        extractedData.forEach((productId, productData) {
          _items.add(Product(
            description: productData['description'],
            id: productId,
            imageUrl: productData['imageUrl'],
            price: productData['price'],
            title: productData['title'],
            isFavourite:
                extractedFav == null ? false : extractedFav[productId] ?? false,
          ));
        });
      }
    } on SocketException catch (error) {
      debugPrint(error.toString());
      throw HttpException('No Internet! Please check your network connection.');
    } on HttpException catch (error) {
      throw error;
    } catch (error) {
      debugPrint(error.toString());
      throw HttpException('Products could not be loaded');
    }
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final url =
        'https://flutter-shop-app-6ecaa.firebaseio.com/products/${product.id}.json?auth=$authToken';
    final productIndex =
        _items.indexWhere((element) => element.id == product.id);
    try {
      if (!(productIndex >= 0)) {
        return;
      }
      final response = await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));

      if (response.body.contains('not found'))
        throw HttpException('item not found!');
      final extractedData = json.decode(response.body);

      if (extractedData['error'] != null) {
        throw HttpException(extractedData['error']);
      }

      if (extractedData['title'] != null) _items[productIndex] = product;
    } on SocketException catch (error) {
      debugPrint(error.toString());
      throw HttpException('No Internet! Please check your network connection.');
    } on HttpException catch (error) {
      throw error;
    } catch (error) {
      debugPrint(error.toString());
      throw (error);
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-shop-app-6ecaa.firebaseio.com/products/$id.json?auth=$authToken';
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200)
        _items.removeWhere((element) => element.id == id);
      else
        throw HttpException('Could not delete product');
    } on SocketException catch (error) {
      debugPrint(error.toString());
      throw HttpException('No Internet! Please check your network connection.');
    } on HttpException catch (error) {
      throw error;
    } catch (error) {
      debugPrint(error.toString());
      throw (error);
    }
    notifyListeners();
  }
}
