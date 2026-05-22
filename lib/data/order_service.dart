import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getPrices(int productId) async {
    final response = await _client
        .from('product_prices')
        .select()
        .eq('product_id', productId)
        .order('price', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addToCart(Map<String, dynamic> data) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final existing = await _client
        .from('cart')
        .select()
        .eq('user_id', user.id)
        .eq('product_id', data['product_id'])
        .eq('size_name', data['size_name'])
        .eq('syrup', data['syrup'])
        .maybeSingle();

    if (existing != null) {
      final newQty = (existing['quantity'] ?? 1) + (data['quantity'] ?? 1);
      await _client
          .from('cart')
          .update({'quantity': newQty})
          .eq('id', existing['id']);
    } else {
      await _client.from('cart').insert(data);
    }
  }

  Future<void> updateCartItem(int cartItemId, Map<String, dynamic> data) async {
    await _client.from('cart').update(data).eq('id', cartItemId);
  }
}