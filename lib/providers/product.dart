import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
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
  Future<void> toggleFavouriteStatus() async {
    final _firebase =
        'https://flutter-shop-app-6ecaa.firebaseio.com/products/$id.json';
    try {
      isFavourite = !isFavourite;
      notifyListeners();
      final response = await http.patch(
        _firebase,
        body: json.encode({'isFavourite': isFavourite}),
      );
      if(response.statusCode >=400 )
      throw HttpException('Favourite status could not be updated!');
    } catch (error) {
      debugPrint(error.toString());
      isFavourite = !isFavourite;
      notifyListeners();
      throw (error);
    }
  }
}
