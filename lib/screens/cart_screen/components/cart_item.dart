import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart.dart';
import '.././../../helpers.dart';

class CartItem extends StatelessWidget {
  final String id, title;
  final double price;
  final int quantity;
  final String productId;

  CartItem(Key key,{
    @required this.quantity,
    @required this.productId,
    @required this.price,
    @required this.title,
    @required this.id,
  }) : super(key: key);

  void decreaseQuantity(BuildContext context) {
    if (quantity > 1) {
      Provider.of<Cart>(context, listen: false).decreaseQuantity(productId);
    } else {
      Provider.of<Cart>(context, listen: false).removeItem(productId);
      showSnackBar(context, 'You could also swipe left to delete the product',
          duration: 3, textScaleFactor: 1.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child:
                    FittedBox(child: Text('\u20B9${price.toStringAsFixed(2)}')),
              ),
            ),
            title: Text(title),
            subtitle:
                Text('Total: \u20B9${(price * quantity).toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => decreaseQuantity(context),
                ),
                Text('$quantity x'),
                IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false)
                          .addItem(productId, title, price);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
