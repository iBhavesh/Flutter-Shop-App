import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../product_detail_screen/product_detail_screen.dart';
import '../../../helpers.dart' show showSnackBar;
import '../../../providers/product.dart';
import '../../../providers/cart.dart';

class ProductItem extends StatelessWidget {
  Future<void> toggleFavourite(BuildContext context) async {
    try {
      await Provider.of<Product>(context, listen: false)
          .toggleFavouriteStatus();
          showSnackBar(context, 'Success!' );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: FadeInImage.memoryNetwork(
            image: product.imageUrl,
            placeholder: kTransparentImage,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Consumer<Product>(
              builder: (ctx, product, _) => Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
              ),
            ),
            onPressed: () => toggleFavourite(context),
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          trailing: CartIconButton(product),
        ),
      ),
    );
  }
}

class CartIconButton extends StatefulWidget {
  final Product product;

  CartIconButton(this.product);

  @override
  _CartIconButtonState createState() => _CartIconButtonState();
}

class _CartIconButtonState extends State<CartIconButton> {
  var _isLoading = false;

  Future<void> addItemToCart(BuildContext context, ThemeData theme) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Cart>(context, listen: false).addItem(
          widget.product.id, widget.product.title, widget.product.price);
      showSnackBar(context, 'Item added!');
    } catch (error) {
      showSnackBar(context, error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final theme = Theme.of(context);
    if (cart.isItemInCart(widget.product.id)) {
      return IconButton(
        icon: Icon(Icons.shopping_cart),
        onPressed: () {
          showSnackBar(
              context, 'Item already exists in cart! Change quantity there!');
        },
        color: theme.accentColor,
      );
    }

    return _isLoading
        ? CircularProgressIndicator()
        : IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              addItemToCart(context, theme);
            },
            color: theme.accentColor,
          );
  }
}
