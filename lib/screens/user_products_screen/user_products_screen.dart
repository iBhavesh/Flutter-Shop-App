import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/app_drawer.dart';
import '../../providers/products.dart';
import './components/user_product_item.dart';
import '../edit_product_screen/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, index) => UserProductItem(
            id: productsData.items[index].id,
            imageUrl: productsData.items[index].imageUrl,
            title: productsData.items[index].title,
          ),
        ),
      ),
    );
  }
}
