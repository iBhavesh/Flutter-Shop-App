import 'package:flutter/material.dart';

import '../screens/orders_screen/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Shop App'),
            automaticallyImplyLeading: false,
          ),
          Divider(thickness: 0.5),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(thickness: 0.5),
          ListTile(
            leading: Icon(Icons.payment),
            title: const Text('Your Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(thickness: 0.5),
        ],
      ),
    );
  }
}
