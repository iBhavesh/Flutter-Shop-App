import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../product_detail_screen/product_detail_screen.dart';
import '../../../helpers.dart' show showSnackBar;
import '../../../providers/product.dart';
import '../../../providers/cart.dart';

class ProductItem extends StatelessWidget {
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
              builder: (ctx, product, _x) => Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
              ),
            ),
            onPressed: product.toggleFavouriteStatus,
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          trailing: Consumer<Cart>(
            builder: (_, cart, ch) =>
                buildCartIconButton(cart, product, context),
          ),
        ),
      ),
    );
  }

  IconButton buildCartIconButton(
      Cart cart, Product product, BuildContext context) {
    if (cart.isItemInCart(product.id)) {
      return IconButton(
        icon: Icon(Icons.shopping_cart),
        onPressed: () {
          showSnackBar(
              context, 'Item already exists in cart! Change quantity there!');
        },
        color: Theme.of(context).accentColor,
      );
    }

    return IconButton(
      icon: Icon(Icons.shopping_cart_outlined),
      onPressed: () {
        cart.addItem(product.id, product.title, product.price);
        showSnackBar(context, 'Item added!');
      },
      color: Theme.of(context).accentColor,
    );
  }
}
