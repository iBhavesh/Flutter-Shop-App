import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/app_drawer.dart';
import '../../providers/products.dart';
import './components/user_product_item.dart';
import '../edit_product_screen/edit_product_screen.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  var _isLoading = false;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(filterByUser: true)
        .catchError((error) {
      return showDialog<Null>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text(
            error.toString(),
          ),
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
    }).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _deleteItem(String id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Products>(context, listen: false).deleteProduct(id);
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text(
            error.toString(),
          ),
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              child: productsData.items.length < 1
                  ? Center(
                      child: Text(
                        'You dont have any Products. Add some.',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: productsData.items.length,
                        itemBuilder: (_, index) => UserProductItem(
                          deleteItem: _deleteItem,
                          id: productsData.items[index].id,
                          imageUrl: productsData.items[index].imageUrl,
                          title: productsData.items[index].title,
                        ),
                      ),
                    ),
              onRefresh: () async {
                await Provider.of<Products>(context, listen: false)
                    .fetchAndSetProducts(filterByUser: true);
              },
            ),
    );
  }
}
