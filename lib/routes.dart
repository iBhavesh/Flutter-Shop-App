import 'package:flutter/material.dart';

import './screens/products_overview_screen/products_overview_screen.dart';
import './screens/product_detail_screen/product_detail_screen.dart';
import './screens/cart_screen/cart_screen.dart';
import './screens/orders_screen/orders_screen.dart';
import './screens/user_products_screen/user_products_screen.dart';
import './screens/edit_product_screen/edit_product_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext _) => ProductsOverviewScreen() ,
  ProductDetailScreen.routeName: (BuildContext _) =>
      ProductDetailScreen(),
  CartScreen.routeName: (BuildContext _) => CartScreen(),
  OrdersScreen.routeName: (BuildContext _) => OrdersScreen(),
  UserProductsScreen.routeName: (BuildContext _) => UserProductsScreen(),
  EditProductScreen.routeName: (BuildContext _) => EditProductScreen(),
};
