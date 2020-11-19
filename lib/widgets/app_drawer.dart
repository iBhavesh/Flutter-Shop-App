import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen/orders_screen.dart';
import '../screens/user_products_screen/user_products_screen.dart';
import '../providers/auth.dart';

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
            icon: Icons.shopping_cart,
            handler: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          DrawerItem(
            title: 'Your Orders',
            icon: Icons.payment,
            handler: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          DrawerItem(
            title: 'User Products',
            icon: Icons.edit,
            handler: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          DrawerItem(
            title: 'Logout',
            icon: Icons.logout,
            handler: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function handler;

  const DrawerItem({
    @required this.icon,
    @required this.title,
    @required this.handler,
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
          onTap: handler,
        ),
        Divider(thickness: 0.5),
      ],
    );
  }
}
