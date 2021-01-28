import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './cart_item.dart';
import '../../../providers/cart.dart' show Cart;
import '../../../providers/orders.dart';
import '../../../helpers/helpers.dart';

class CartBody extends StatefulWidget {
  const CartBody({
    Key key,
  }) : super(key: key);

  @override
  _CartBodyState createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  var _isLoading = false;
  var _isInitialised = false;

  @override
  void didChangeDependencies() {
    if (!_isInitialised) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Cart>(context, listen: false)
          .fetchAndSetCart()
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
    final cart = Provider.of<Cart>(context);
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
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
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .color,
                          ),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      OrderButton(cart: cart),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;

  Future<void> placeOrder(BuildContext context) async {
    try {
      if (widget.cart.items.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        await Provider.of<Orders>(context, listen: false)
            .addOrder(widget.cart.items, widget.cart.totalAmount);
        await widget.cart.clearCart();
        showSnackBar(context, 'Order Placed', duration: 2);
      } else {
        showSnackBar(context, 'Cart is empty! order cannot be placed',
            duration: 2);
      }
    } catch (error) {
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
    }
    finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: isLoading ? Center(child: CircularProgressIndicator()) : Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
      onPressed: widget.cart.totalAmount > 0.00 ? () => placeOrder(context) : null,
    );
  }
}
