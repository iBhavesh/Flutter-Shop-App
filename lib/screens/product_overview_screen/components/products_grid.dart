import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/products.dart';
import '../../../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, index) => ProductItem(
        imageUrl: products[index].imageUrl,
        title: products[index].title,
        id: products[index].id,
      ),
      itemCount: products.length,
    );
  }
}