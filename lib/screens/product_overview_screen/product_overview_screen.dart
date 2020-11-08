import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/products_grid.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/cart_widget.dart';
import '../../providers/products.dart';
import '../../helpers.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavouritesOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop',
        ),
        actions: [
          Builder(builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.arrow_circle_up),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .uploadData();
                  debugPrint('test');
                  showSnackBar(context, 'Upload Successful');
                } catch (error) {
                  showSnackBar(
                    context,
                    'Oops! Something went wrong!',
                    duration: 2,
                  );
                }
              },
            );
          }),
          CartWidget(),
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.Favourites) {
                  _showFavouritesOnly = true;
                } else {
                  _showFavouritesOnly = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favourites'),
                  value: FilterOptions.Favourites),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showFavouritesOnly),
    );
  }
}
