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

    await _client.from('users').update({
      if (name != null) 'name': name,
      if (email != null) 'email': email,
    }).eq('id', user.id);
  }

  Future<String?> uploadAvatar(File file, {String name = ''}) async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final path = 'avatars/${user.id}.jpg';

    print('user id: ${user.id}');
    print('path: $path');
    try {
      // конвертируем в JPEG независимо от исходного формата
      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return null;
      final compressed = img.encodeJpg(decoded, quality: 80);

      await _client.storage.from('avatars').uploadBinary(
        path,
        Uint8List.fromList(compressed),
        fileOptions: const FileOptions(
          upsert: true,
          contentType: 'image/jpeg',
        ),
      );

      final url = _client.storage.from('avatars').getPublicUrl(path);

      await _client.from('users')
          .update({'avatar_url': url})
          .eq('id', user.id);

      return url;
    } catch (e) {
      print('Ошибка загрузки аватара: $e');
      return null;
    }
  }
}