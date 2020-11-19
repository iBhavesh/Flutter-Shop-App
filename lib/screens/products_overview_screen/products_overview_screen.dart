import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products.dart';
import '../../providers/cart.dart';
import 'components/products_grid.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/cart_widget.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavouritesOnly = false;
  var _isInitialised = false;
  var _isLoading = false;

  Future<void> _showDialog(String content) async {
    return showDialog<Null>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text(content),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_isInitialised) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        return Provider.of<Cart>(context, listen: false)
            .fetchAndSetCart()
            .catchError((error) {
          return _showDialog(error.toString());
        });
      }).catchError((error) {
        return _showDialog(error.toString());
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      _isInitialised = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Shop',
        ),
        actions: [
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showFavouritesOnly),
    );
  }
}
