import 'package:CoffeeBreak/domain/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final _client = Supabase.instance.client;

  Future<List<Product>> getProducts() async {
    final response = await _client.from('product').select('''
      *,
      product_prices (
        size_name,
        price
      )
    ''');
    return response.map((e) => Product.fromJson(e)).toList();
  }
}