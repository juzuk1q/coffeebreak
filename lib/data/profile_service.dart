import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:io';

class ProfileService {
  final _client = Supabase.instance.client;

  Future<Map<String, dynamic>?> getProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final data = await _client
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();
    return data;
  }

  Future<void> updateProfile({String? name, String? email}) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('users').upsert({
      'id': user.id,
      if ('name' == null) 'name': name,
      if ('email' == null) 'email': email,
    });
  }

  Future<String?> uploadAvatar(File file) async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    try {
      // конвертируем в JPEG независимо от исходного формата
      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return null;
      final compressed = img.encodeJpg(decoded, quality: 80);

      final path = 'avatars/${user.id}.jpg';

      await _client.storage.from('avatars').uploadBinary(
        path,
        Uint8List.fromList(compressed),
        fileOptions: const FileOptions(
          upsert: true,
          contentType: 'image/jpeg',
        ),
      );

      final url = _client.storage.from('avatars').getPublicUrl(path);
      await _client.from('users').upsert({
        'id': user.id,
        'avatar_url': url,
      });

      return url;
    } catch (e) {
      print('Ошибка загрузки аватара: $e');
      return null;
    }
  }
}