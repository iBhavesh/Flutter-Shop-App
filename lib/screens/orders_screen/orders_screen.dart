import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_drawer.dart';

import '../../providers/orders.dart' show Orders;
import './components/order_item.dart';
import '../../providers/cart.dart';
import '../../widgets/badge.dart';
import '../cart_screen/cart_screen.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: orders.orders.isEmpty
          ? Center(
              child: const Text(
              'You haven\'t ordered anything yet :(',
              style: TextStyle(fontSize: 24),
              softWrap: true,
            ))
          : ListView.builder(
              itemCount: orders.orders.length,
              itemBuilder: (_, index) => OrderItem(orders.orders[index]),
            ),
      drawer: AppDrawer(),
    );
  }
}
