import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/products.dart';
import '../../../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavouritesOnly;
  const ProductsGrid(
    this.showFavouritesOnly, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavouritesOnly ? productsData.favouriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
      itemCount: products.length,
    );
  }
}
