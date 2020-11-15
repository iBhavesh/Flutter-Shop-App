import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class CartItem {
  final String id, title;
  final double price;
  final int quantity;
  CartItem({
    @required this.id,
    @required this.price,
    @required this.title,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  Future<void> addItem(String productId, String title, double price) async {
    if (_items.containsKey(productId)) {
      final url =
          'https://flutter-shop-app-6ecaa.firebaseio.com/cart/${_items[productId].id}.json';
      try {
        final response = await http.patch(
          url,
          body: json.encode({
            'quantity': _items[productId].quantity + 1,
          }),
        );
        // debugPrint('${response.statusCode}');
        if (response.statusCode >= 400) {
          throw HttpException('Item could not be added to cart!');
        } else {
          _items.update(
            productId,
            (value) => CartItem(
              id: value.id,
              price: value.price,
              title: value.title,
              quantity: value.quantity + 1,
            ),
          );
        }
        notifyListeners();
      } catch (error) {
        debugPrint(error.toString());
        throw HttpException('Item could not be added to cart!');
      }
    } else {
      final url = 'https://flutter-shop-app-6ecaa.firebaseio.com/cart.json';
      try {
        final response = await http.post(
          url,
          body: json.encode({
            'productId': productId,
            'price': price,
            'title': title,
            'quantity': 1
          }),
        );
        // debugPrint('${response.statusCode}');
        if (response.statusCode == 200) {
          _items.putIfAbsent(
            productId,
            () => CartItem(
              id: json.decode(response.body)['name'],
              price: price,
              title: title,
              quantity: 1,
            ),
          );
        }
        notifyListeners();
      } catch (error) {
        debugPrint(error.toString());
        throw HttpException('Item could not be added!');
      }
    }
  }

  int get itemCount {
    int itemCount = 0;
    _items.forEach(
      (key, value) {
        itemCount += value.quantity;
      },
    );
    return itemCount;
  }

  double get totalAmount {
    double total = 0.00;
    _items.forEach((key, value) {
      total += (value.price * value.quantity);
    });
    return total;
  }

  Future<void> removeItem(String productId) async {
    final url =
        'https://flutter-shop-app-6ecaa.firebaseio.com/${_items[productId].id}.json';
    try {
      final response = await http.delete(url);
      // debugPrint('${response.statusCode}');
      if (response.statusCode >= 400) {
        throw HttpException('Item could not be removed from Cart');
      } else {
        _items.remove(productId);
      }
    } catch (error) {
      debugPrint(error.toString());
      throw (error);
    }

    notifyListeners();
  }

  Future<void> decreaseQuantity(String productId) async {
    if (_items.containsKey(productId)) {
      final url =
          'https://flutter-shop-app-6ecaa.firebaseio.com/cart/${_items[productId].id}.json';
      try {
        final response = await http.patch(
          url,
          body: json.encode({
            'quantity': _items[productId].quantity - 1,
          }),
        );
        // debugPrint('${response.statusCode}');
        if (response.statusCode >= 400) {
          throw HttpException('Item could not be removed from Cart');
        } else {
          _items.update(
            productId,
            (value) => CartItem(
              id: value.id,
              price: value.price,
              title: value.title,
              quantity: value.quantity - 1,
            ),
          );
        }
      } catch (error) {
        debugPrint(error.toString());
        throw (error);
      }
    }
    notifyListeners();
  }

  bool isItemInCart(String productId) {
    return _items.containsKey(productId);
  }

  Future<void> clearCart() async {
    final url = 'https://flutter-shop-app-6ecaa.firebaseio.com/cart.json';
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200)
        _items = {};
      else
        throw HttpException('Could not clear cart');
    } catch (error) {
      debugPrint(error.toString());
      throw HttpException('Could not clear cart');
    }
    notifyListeners();
  }

  Future<void> fetchAndSetCart() async {
    final url = 'https://flutter-shop-app-6ecaa.firebaseio.com/cart.json';
    try {
      final response = await http.get(url);
      _items.clear();
      if (json.decode(response.body) != null) {
        final extractedResponse =
            json.decode(response.body) as Map<String, dynamic>;
        extractedResponse.forEach((key, value) {
          _items.putIfAbsent(
              value['productId'],
              () => CartItem(
                    id: key,
                    price: value['price'],
                    title: value['title'],
                    quantity: value['quantity'],
                  ));
        });
        notifyListeners();
      }
    } on SocketException catch (error) {
      debugPrint(error.toString());
      throw HttpException('No Internet! Please check your network connection.');
    } catch (error) {
      debugPrint(error.toString());
      throw HttpException('Cart Items could not be fetched');
    }
  }
}
