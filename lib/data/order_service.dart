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
    await _client.from('cart').insert(data);
  }

  Future<void> updateCartItem(int cartItemId, Map<String, dynamic> data) async {
    await _client.from('cart').update(data).eq('id', cartItemId);
  }
}