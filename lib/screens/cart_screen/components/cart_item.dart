import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id, title;
  final double price;
  final int quantity;

  CartItem({
    @required this.quantity,
    @required this.price,
    @required this.title,
    @required this.id,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
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
              child: FittedBox(child: Text('\u20B9${price.toStringAsFixed(2)}')),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total: \u20B9${(price * quantity)}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
