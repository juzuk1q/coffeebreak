import 'package:CoffeeBreak/domain/models/cart_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartService {
  final _client = Supabase.instance.client;

  Future<List<CartItem>> getCart() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final data = await _client.from('cart').select('''
      *,
      product:product_id (
        id,
        name,
        image_path,
        description,
        product_prices (
          price,
          size_name
        )
      )
    ''').eq('user_id', user.id);

    return data.map((e) => CartItem.fromJson(e)).toList();
  }

  Future<void> deleteItem(int id) async {
    await _client.from('cart').delete().eq('id', id);
  }

  Future<void> updateQuantity(int id, int count) async {
    await _client.from('cart').update({'quantity': count}).eq('id', id);
  }
}