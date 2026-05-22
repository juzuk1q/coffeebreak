import 'dart:convert';
import 'package:CoffeeBreak/data/cart_service.dart';
import 'package:CoffeeBreak/domain/models/cart_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final _client = Supabase.instance.client;
  final _cartService = CartService();

  Future<void> placeOrder(List<CartItem> items) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final total = items.fold(0, (sum, item) => sum + item.totalPrice);

    await _client.from('orders').insert({
      'user_id': user.id,
      'items': jsonEncode(items.map((e) => e.toJson()).toList()),
      'total': total,
    });

    await _cartService.clearCart();
  }
}