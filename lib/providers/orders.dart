import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime orderTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.orderTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    try {
      final url = 'https://flutter-shop-app-6ecaa.firebaseio.com/orders.json';
      final orderTime = DateTime.now();
      List<Map<String, dynamic>> productList = [];
      cartProducts.forEach((element) {
        productList.add({
          'id': element.id,
          'price': element.price,
          'quantity': element.quantity,
          'title': element.title,
        });
      });

      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'orderTime': orderTime.toString(),
          'products': productList,
        }),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          orderTime: orderTime,
          products: cartProducts,
        ),
      );
    } catch (error) {
      debugPrint(error.toString());
      throw (error);
    }
    notifyListeners();
  }
}
