import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../widgets/product_item.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop',
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (_, index) => ProductItem(
          imageUrl: dummyProducts[index].imageUrl,
          title: dummyProducts[index].title,
          id: dummyProducts[index].id,
        ),
        itemCount: dummyProducts.length,
      ),
    );
  }
}
