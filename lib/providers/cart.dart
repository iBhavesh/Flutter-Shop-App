import 'dart:convert';

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
    final url = 'https://flutter-shop-app-6ecaa.firebaseio.com/${_items[productId].id}.json';
      try {
        final response = await http.patch(
          url,
          body: json.encode({
            'quantity': _items[productId].quantity + 1,
          }),
        );
        debugPrint('${response.statusCode}');
        if (response.statusCode >= 400) {
          throw HttpException('Item could not be added to Cart');
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
      } catch (error) {
        debugPrint(error.toString());
        throw (error);
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
      } catch (error) {
        debugPrint(error.toString());
        throw (error);
      }
    }
    notifyListeners();
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

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
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
    notifyListeners();
  }

  bool isItemInCart(String productId) {
    return _items.containsKey(productId);
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
