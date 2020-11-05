import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen/cart_screen.dart';
import '../providers/cart.dart';
import './badge.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
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
    );
  }
}