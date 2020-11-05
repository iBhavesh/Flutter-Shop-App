import 'package:flutter/material.dart';

import '../screens/orders_screen/orders_screen.dart';
import '../screens/user_products_screen/user_products_screen.dart';

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
          DrawerItem(
            title: 'Shop',
            routeName: '/',
            icon: Icons.shopping_cart,
          ),
          DrawerItem(
            title: 'Your Orders',
            routeName: OrdersScreen.routeName,
            icon: Icons.payment,
          ),
          DrawerItem(
            title: 'User Products',
            routeName: UserProductsScreen.routeName,
            icon: Icons.edit,
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String routeName, title;
  final IconData icon;

  const DrawerItem({
    @required this.icon,
    @required this.title,
    @required this.routeName,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(routeName);
          },
        ),
        Divider(thickness: 0.5),
      ],
    );
  }
}
