import 'package:flutter/material.dart';

import '../../edit_product_screen/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String imageUrl, title, id;
  final Function deleteItem;

  UserProductItem({
    @required this.deleteItem,
    @required this.id,
    @required this.imageUrl,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () => deleteItem(id),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
