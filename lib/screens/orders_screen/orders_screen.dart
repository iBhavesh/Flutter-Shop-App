import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_drawer.dart';

import '../../providers/orders.dart' show Orders;
import './components/order_item.dart';
import '../../widgets/cart_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
        actions: [
          CartWidget(),
        ],
      ),
      body: orders.orders.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  'You haven\'t ordered anything yet :(',
                  style: TextStyle(fontSize: 24),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              itemCount: orders.orders.length,
              itemBuilder: (_, index) => OrderItem(orders.orders[index]),
            ),
      drawer: AppDrawer(),
    );
  }
}
