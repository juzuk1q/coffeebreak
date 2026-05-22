import 'dart:io';
import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/constant/text_styles.dart';
import 'package:CoffeeBreak/core/widgets/app_bar.dart';
import 'package:CoffeeBreak/data/auth_service.dart';
import 'package:CoffeeBreak/data/profile_service.dart';
import 'package:CoffeeBreak/presentation/favourite/favourites_screen.dart';
import 'package:vize/vize.dart';
import 'package:CoffeeBreak/presentation/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _name;
  String? _email;
  String? _avatarUrl;
  bool _isLoading = true;
  final supabase = Supabase.instance.client;
  final _authService = AuthService();
  final _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  Future<void> _loadProfile() async {
    final data = await _profileService.getProfile();
    if (mounted) {
      setState(() {
        _name = data?['name'];
        _email = data?['email'];
        _avatarUrl = data?['avatar_url'];
        _isLoading = false;
      });
    }
  }

  Future<void> _editField(String label, String? current, Function(String) onSave) async {
    final controller = TextEditingController(text: current ?? '');
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20.r)),
      ),
      builder: (context) => Padding(
        padding: po(
          l: 24, r: 24, t: 24,
          b: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TxtStyle.m18),
            SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColor.gray.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: .circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, controller.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.main,
                  shape: RoundedRectangleBorder(borderRadius: .circular(12.r)),
                ),
                child: Text('Сохранить', style: TxtStyle.m16),
              ),
            ),
          ],
        ),
      ),
    );

    if (result != null && result.isNotEmpty) {
      onSave(result);
    }
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80
    );
    if (picked == null) return;

    setState(() => _isLoading = true);
    try {
      final url = await _profileService.uploadAvatar(File(picked.path));
      if (url != null) setState(() => _avatarUrl = '$url?t=${DateTime.now().millisecondsSinceEpoch}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppHeader(
        txt: 'Профиль',
        actions: [
          GestureDetector(
            onTap: _signOut,
            child: SvgPicture.asset('assets/icons/exit.svg'),
          ),
        ],
      ),
      // todo: доделать профиль, а то ты ленивый какой-то..
      body: Padding(
        padding: pa(20),
        child: Column(
          children: [
            // Аватар
            GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColor.gray.withOpacity(0.6),
                    backgroundImage: _avatarUrl != null
                        ? NetworkImage(_avatarUrl!, headers: {'Cache-Control': 'no-cache'})
                        : null,
                    child: _avatarUrl == null
                        ? Icon(Icons.person, size: 55, color: AppColor.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: AppColor.gray,
                        shape: BoxShape.circle,
                        border: .all(color: AppColor.white, width: 3)
                      ),
                      child: Icon(Icons.edit, size: 16, color: AppColor.navbar),
                    ),
                  ),
                ],
              ),
            ),
            fhs(24),

            // name and email
            Container(
              width: 322.w,
              decoration: BoxDecoration(
                color: AppColor.gray.withOpacity(0.35),
                borderRadius: .circular(15.r)
              ),
              padding: po(l: 16, r:16, t: 12, b: 2),
              child: Column(
                children: [
                  // name
                  GestureDetector(
                    onTap: () {
                      _editField('Имя', _name, (val) async {
                        await _profileService.updateProfile(name: val);
                        setState(() => _name = val);
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text("Имя", style: TxtStyle.m14(color: AppColor.description)),
                                if (_name != null) ...[
                                  SizedBox(height: 4),
                                  Text(_name!, style: TxtStyle.m14(color: AppColor.text)),
                                ],
                              ],
                            ),
                          ),
                          Icon(
                            Icons.edit,
                            size: 18,
                            color: AppColor.description,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(indent: 16, endIndent: 16, color: AppColor.gray,),
                  
                  // email
                  GestureDetector(
                    onTap: () {
                      _editField('Почта', _email, (val) async {
                      await _profileService.updateProfile(email: val);
                      setState(() => _email = val);
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text("Почта", style: TxtStyle.m14(color: AppColor.description)),
                                if (_email != null) ...[
                                  SizedBox(height: 4),
                                  Text(_email!, style: TxtStyle.m14(color: AppColor.text)),
                                ],
                              ],
                            ),
                          ),
                          Icon(
                            Icons.edit,
                            size: 18,
                            color: AppColor.description,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 24),

            // кнопка избранное
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavouritesScreen()));
              },
              child: Container(
                width: double.infinity,
                padding: ps(h: 16, v: 12),
                decoration: BoxDecoration(
                  color: AppColor.card,
                  borderRadius: .circular(12.r),
                ),
                child: Row(
                  children: [
                    Text('Избранное', style: TxtStyle.m14(color: AppColor.description)),
                    Spacer(),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: AppColor.description,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
