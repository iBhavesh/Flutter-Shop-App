import 'package:flutter/foundation.dart';

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

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          price: value.price,
          title: value.title,
          quantity: value.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          quantity: 1,
        ),
      );
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
}
