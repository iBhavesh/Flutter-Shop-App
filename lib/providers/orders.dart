import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import './cart.dart';

class OrderItem {
  final String orderId;
  final double totalAmount;
  final List<Map<String, dynamic>> products;
  final DateTime orderTime;
  OrderItem({
    @required this.orderId,
    @required this.totalAmount,
    @required this.products,
    @required this.orderTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken, userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(
      Map<String, CartItem> cartItems, double totalAmount) async {
    final orderTime = DateTime.now();
    List<Map<String, dynamic>> products = [];
    cartItems.forEach((key, value) {
      products.add({
        'productId': key,
        'quantity': value.quantity,
        'price': value.price,
      });
    });
    final url =
        'https://flutter-shop-app-6ecaa.firebaseio.com/orders/$userId.json?auth=$authToken';
    debugPrint('$products');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'products': products,
          'orderTime': orderTime.toIso8601String(),
          'totalAmount': totalAmount,
        }),
      );

      if (response.statusCode >= 400) {
        // debugPrint(response.body);
        throw HttpException('Item could not be added to cart!');
      } else {
        _orders.insert(
            0,
            OrderItem(
              orderId: json.decode(response.body)['name'],
              totalAmount: totalAmount,
              products: products,
              orderTime: orderTime,
            ));
        notifyListeners();
      }
    } on SocketException catch (error) {
      debugPrint(error.toString());
      throw HttpException('No Internet! Please check your network connection.');
    } catch (error) {
      debugPrint('$error');
      throw HttpException('Oops an error occured! Order Could not be placed.');
    }
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-shop-app-6ecaa.firebaseio.com/orders/$userId.json?auth=$authToken';
    _orders.clear();
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData['error'] != null) {
        throw HttpException(extractedData['error']);
      }
      if (extractedData != null) {
        extractedData.forEach((orderId, orderData) {
          final products = (orderData['products'] as List)
              .map((element) => {
                    'price': element['price'],
                    'productId': element['productId'],
                    'quantity': element['quantity'],
                  })
              .toList();
          debugPrint('$products');
          debugPrint('after');
          _orders.insert(
              0,
              OrderItem(
                orderId: orderId,
                totalAmount: orderData['totalAmount'],
                products: products,
                orderTime: DateTime.tryParse(orderData['orderTime']),
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
      throw HttpException('Orders could not be loaded');
    }
    notifyListeners();
  }
}
