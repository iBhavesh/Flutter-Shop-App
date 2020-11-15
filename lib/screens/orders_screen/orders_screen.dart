import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_drawer.dart';

import '../../providers/orders.dart' show Orders;
import './components/order_item.dart';
import '../../widgets/cart_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  var _isInitialised = false;

  @override
  void didChangeDependencies() {
    if (!_isInitialised) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context, listen: false)
          .fetchAndSetOrders()
          .catchError((error) {
        return showDialog<Null>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text(
              error.toString(),
            ),
            actions: [
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInitialised = true;
    }
    super.didChangeDependencies();
  }

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.orders.isEmpty
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
