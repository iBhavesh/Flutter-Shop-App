import 'package:flutter/material.dart';
import '../../../providers/product.dart';

class DetailScreenBody extends StatelessWidget {
  final Product loadedProduct;
  final MediaQueryData mediaQuery;

  DetailScreenBody({
    @required this.loadedProduct,
    @required this.mediaQuery,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(loadedProduct.title),
            background: Container(
              height: (mediaQuery.size.height -
                      mediaQuery.padding.top -
                      kToolbarHeight) *
                  0.4,
              width: double.infinity,
              child: Hero(
                tag: loadedProduct.imageUrl,
                child: FadeInImage.assetNetwork(
                  image: loadedProduct.imageUrl,
                  placeholder: 'assets/images/produt-placeholder.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10),
            Text(
              '\u20B9${loadedProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '${loadedProduct.description}',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            SizedBox(height: 800),
          ]),
        ),
      ],
    );
  }
}
