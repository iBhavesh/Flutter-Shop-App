import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart.dart';
import '../../../helpers/helpers.dart';

class CartItem extends StatelessWidget {
  final String id, title;
  final double price;
  final int quantity;
  final String productId;

  CartItem(
    Key key, {
    @required this.quantity,
    @required this.productId,
    @required this.price,
    @required this.title,
    @required this.id,
  }) : super(key: key);

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
                CustomIconButton(
                  icon: Icons.remove_circle,
                  productId: productId,
                  title: title,
                  price: price,
                  quantity: quantity,
                ),
                Text('$quantity x'),
                CustomIconButton(
                  icon: Icons.add_circle,
                  productId: productId,
                  title: title,
                  price: price,
                  quantity: quantity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatefulWidget {
  const CustomIconButton({
    Key key,
    @required this.icon,
    @required this.productId,
    @required this.title,
    @required this.price,
    @required this.quantity,
  }) : super(key: key);

  final IconData icon;
  final int quantity;
  final String productId;
  final String title;
  final double price;

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  var isLoading = false;

  Future<void> decreaseQuantity(BuildContext context) async {
    try {
      if (widget.quantity > 1) {
        await Provider.of<Cart>(context, listen: false)
            .decreaseQuantity(widget.productId);
      } else {
        await Provider.of<Cart>(context, listen: false)
            .removeItem(widget.productId);
        showSnackBar(context, 'You could also swipe left to delete the product',
            duration: 3, textScaleFactor: 1.2);
      }
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            child: CircularProgressIndicator(),
            padding: const EdgeInsets.all(8.0),
          )
        : IconButton(
            icon: Icon(
              widget.icon,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              try {
                setState(() {
                  isLoading = true;
                });
                if (widget.icon == Icons.add_circle)
                  await Provider.of<Cart>(context, listen: false)
                      .addItem(widget.productId, widget.title, widget.price);
                else
                  await decreaseQuantity(context);
              } catch (error) {
                showSnackBar(context, error.toString());
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            });
  }
}
