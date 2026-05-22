import 'dart:convert';
import 'package:CoffeeBreak/domain/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesService {
  static const _key = 'local_favourites';

  Future<List<Product>> getFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded.map((e) => Product.fromJson(e)).toList();
  }

  Future<bool> isFavourite(int productId) async {
    final items = await getFavourites();
    return items.any((e) => e.id == productId);
  }

  Future<void> toggle(Product product) async {
    final items = await getFavourites();
    final exists = items.any((e) => e.id == product.id);

    if (exists) {
      items.removeWhere((e) => e.id == product.id);
    } else {
      items.add(product);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  Future<void> remove(int productId) async {
    final items = await getFavourites();
    items.removeWhere((e) => e.id == productId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(items.map((e) => e.toJson()).toList()));
  }
}