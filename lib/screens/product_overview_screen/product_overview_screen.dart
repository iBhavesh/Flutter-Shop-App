import 'package:flutter/material.dart';

import 'components/products_grid.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop',
        ),
      ),
      body: ProductsGrid(),
    );
  }
}
