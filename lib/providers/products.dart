import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String userId;
  final String authToken;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite == true).toList();
  }

  // get product
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filter = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    final url = Uri.parse(
      '${dotenv.env['FIREBASE_URL']}/products.json?auth=$authToken&$filter',
    );

    final favUrl = Uri.parse(
      '${dotenv.env['FIREBASE_URL']}/userFavorites/$userId.json?auth=$authToken',
    );

    try {
      final response = await http.get(url);
      if (json.decode(response.body) == null) {
        return;
      }
      final data = json.decode(response.body) as Map<String, dynamic>;

      final favoriteResponse = await http.get(favUrl);

      final List<Product> loadedProduct = [];
      data.forEach((productId, productData) {
        loadedProduct.add(Product(
          id: productId,
          title: productData['title'] as String,
          description: productData['description'] as String,
          price: productData['price'] as double,
          isFavorite: json.decode(favoriteResponse.body) == null
              ? false
              : json.decode(favoriteResponse.body)[productId] == null
                  ? false
                  : json.decode(favoriteResponse.body)[productId]['isFavorite']
                      as bool,
          imageUrl: productData['imageUrl'] as String,
        ));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // post product
  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
      '${dotenv.env['FIREBASE_URL']}/products.json?auth=$authToken',
    );

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // patch product
  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
        '${dotenv.env['FIREBASE_URL']}/products/$id.json?auth=$authToken',
      );
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
    }

    notifyListeners();
  }

  // delete product
  Future<void> deleteProduct(String id) async {
    // optimizing update
    final url = Uri.parse(
      '${dotenv.env['FIREBASE_URL']}/products/$id?auth=$authToken',
    );
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    final response = await http.delete(url);

    _items.removeAt(existingProductIndex);
    notifyListeners();

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
    // _items.removeWhere((prod) => prod.id == id);
  }
}
