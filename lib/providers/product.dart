import 'package:flutter/foundation.dart';

class Product with ChangeNotifier{
  final String id, title, description, imageUrl;
  bool isFavourite;
  final double price;
  Product({
    @required this.description,
    @required this.id,
    @required this.imageUrl,
    @required this.price,
    @required this.title,
    this.isFavourite = false,
  });
  void toggleFavouriteStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
