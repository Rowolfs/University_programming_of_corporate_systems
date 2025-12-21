import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storage_client/storage_client.dart';

import 'package:tier_list_app/services/supabase_client.dart';
import 'package:tier_list_app/pages/greetingsPage.dart';

class ActionAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ActionAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<ActionAppBar> createState() => _ActionAppBarState();
}

class _ActionAppBarState extends State<ActionAppBar> {
  final _picker = ImagePicker();

  String? _avatarUrl;
  bool _loading = false;

  static const _profilesTable = 'profiles';
  static const _bucket = 'avatars';

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final row = await supabase
          .from(_profilesTable)
          .select('avatar_url')
          .eq('id', user.id)
          .maybeSingle();

      if (!mounted) return;
      final url = (row?['avatar_url'] ?? '').toString().trim();
      setState(() => _avatarUrl = url.isEmpty ? null : url);
    } catch (e) {
      debugPrint('Load avatar error: $e');
    }
  }

  Future<void> _signOutAndGoToGreetings() async {
    if (_loading) return;

    setState(() => _loading = true);
    try {
      await supabase.auth.signOut(); // [web:256]
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const GreetingsPage()),
        (route) => false,
      ); // [web:267]
    } catch (e) {
      debugPrint('Sign out error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось выйти из аккаунта'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    if (_loading) return;

    final user = supabase.auth.currentUser;
    if (user == null) return;

    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1024,
    );
    if (picked == null) return;

    setState(() => _loading = true);

    try {
      final Uint8List bytes = await picked.readAsBytes();

      final extRaw = picked.name.contains('.')
          ? picked.name.split('.').last.toLowerCase()
          : 'jpg';
      final ext = (extRaw == 'png' || extRaw == 'jpg' || extRaw == 'jpeg')
          ? extRaw
          : 'jpg';

      final path = '${user.id}/avatar.$ext';

      final bucket = supabase.storage.from(_bucket);

      await bucket.uploadBinary(
        path,
        bytes,
        fileOptions: FileOptions(
          upsert: true,
          cacheControl: '3600',
          contentType: ext == 'png' ? 'image/png' : 'image/jpeg',
        ),
      );

      final url = bucket.getPublicUrl(path);

      await supabase.from(_profilesTable).upsert({
        'id': user.id,
        'avatar_url': url,
      });

      if (!mounted) return;
      setState(() => _avatarUrl = url);
    } catch (e) {
      debugPrint('Upload avatar error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось обновить аватар'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 20.w,
      title: SvgPicture.asset(
        'assets/vectors/Tierly.svg',
        height: 24,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _pickAndUploadAvatar,
              onLongPress: _signOutAndGoToGreetings, // <-- ВЫХОД [web:267]
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                width: 38.w,
                height: 38.w,
                child: _loading
                    ? const Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : (_avatarUrl != null
                        ? ClipOval(
                            child: Image.network(
                              _avatarUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : SvgPicture.asset(
                            'assets/icons/user.svg',
                            height: 35.h,
                          )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
