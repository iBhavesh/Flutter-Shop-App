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
  Future<void> toggleFavouriteStatus(String authToken, String userId) async {
    final url =
        'https://flutter-shop-app-6ecaa.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken';
    try {
      isFavourite = !isFavourite;
      notifyListeners();
      final response = await http.put(
        url,
        body: json.encode(isFavourite),
      );
      if (response.statusCode >= 400)
        throw HttpException('Favourite status could not be updated!');
    } catch (error) {
      debugPrint(error.toString());
      isFavourite = !isFavourite;
      notifyListeners();
      throw (error);
    }
  }
}
