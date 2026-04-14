import 'package:CoffeeBreak/domain/models/additive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdditivesService {
  final _client = Supabase.instance.client;

  Future<List<Additive>> getAdditives() async {
    final response = await _client
        .from('addons')
        .select()
        .eq('category', 'additive');
    return response.map((e) => Additive.fromJson(e)).toList();
  }
}
