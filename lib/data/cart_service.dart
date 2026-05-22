import 'dart:convert';
import 'package:CoffeeBreak/domain/models/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const _key = 'localСart';

  // получить корзину
  Future<List<CartItem>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    final List decoded = jsonDecode(raw);
    return decoded.map((e) => CartItem.fromJson(e)).toList();
  }

  // сохранить корзину
  Future<void> _saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }

  // добавить товар (с проверкой дубликата)
  Future<List<CartItem>> addItem(CartItem newItem) async {
    final items = await getCart();

    final index = items.indexWhere((e) =>
    e.product.id == newItem.product.id &&
        e.sizeName == newItem.sizeName &&
        e.syrup == newItem.syrup);

    if (index != -1) {
      final existing = items[index];
      items[index] = CartItem(
        id: existing.id,
        quantity: existing.quantity + newItem.quantity,
        sizeName: existing.sizeName,
        syrup: existing.syrup,
        additivesIds: existing.additivesIds,
        product: existing.product,
      );
    } else {
      items.add(newItem);
    }

    await _saveCart(items);
    return items;
  }

  // обновить количество
  Future<List<CartItem>> updateQuantity(int id, int count) async {
    final items = await getCart();
    final index = items.indexWhere((e) => e.id == id);
    if (index != -1) {
      final item = items[index];
      items[index] = CartItem(
        id: item.id,
        quantity: count,
        sizeName: item.sizeName,
        syrup: item.syrup,
        additivesIds: item.additivesIds,
        product: item.product,
      );
    }
    await _saveCart(items);
    return items;
  }

  // удалить позицию
  Future<List<CartItem>> deleteItem(int id) async {
    final items = await getCart();
    items.removeWhere((e) => e.id == id);
    await _saveCart(items);
    return items;
  }

  // очистить корзину
  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}