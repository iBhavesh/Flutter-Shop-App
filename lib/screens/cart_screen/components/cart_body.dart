import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './cart_item.dart';
import '../../../providers/cart.dart' show Cart;
import '../../../providers/orders.dart';
import '../../../helpers.dart';

class CartBody extends StatelessWidget {
  const CartBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(15),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    '\u20B9${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryTextTheme.headline6.color,
                    ),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                FlatButton(
                  child: Text('ORDER NOW'),
                  textColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (cart.items.isNotEmpty) {
                      Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(), cart.totalAmount);
                      cart.clearCart();
                      showSnackBar(context, 'Order Placed', duration: 2);
                    }
                    showSnackBar(
                        context, 'Cart is empty! order cannot be placed',
                        duration: 2);
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
            child: ListView.builder(
          itemBuilder: (_, index) => CartItem(
            ValueKey(cart.items.values.toList()[index].id),
            title: cart.items.values.toList()[index].title,
            id: cart.items.values.toList()[index].id,
            productId: cart.items.keys.toList()[index],
            price: cart.items.values.toList()[index].price,
            quantity: cart.items.values.toList()[index].quantity,
          ),
          itemCount: cart.items.length,
        ))
      ],
    );
  }
}
