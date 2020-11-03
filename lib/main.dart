import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_overview_screen/product_overview_screen.dart';
import './screens/product_detail_screen/product_detail_screen.dart';
import './screens/cart_screen/cart_screen.dart';
import './screens/orders_screen/orders_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange[400],
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (BuildContext context) =>
              ProductDetailScreen(),
          CartScreen.routeName: (BuildContext context) => CartScreen(),
          OrdersScreen.routeName: (BuildContext context) => OrdersScreen(),
        },
      ),
    );
  }
}
