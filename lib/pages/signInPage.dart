import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:tier_list_app/pages/homePage.dart';
import 'package:tier_list_app/services/supabase_client.dart';
import 'package:tier_list_app/widgets/actionEditLine.dart';
import 'package:tier_list_app/widgets/actionHeading.dart';
import 'package:tier_list_app/widgets/actionModal.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape; // [web:16]
    return isLandscape ? const SignInPageHorizontal() : const SignInPageVertical();
  }
}

class SignInPageHorizontal extends StatelessWidget {
  const SignInPageHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignInBody(layout: _SignInLayout.horizontal);
  }
}

class SignInPageVertical extends StatelessWidget {
  const SignInPageVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignInBody(layout: _SignInLayout.vertical);
  }
}

enum _SignInLayout { vertical, horizontal }

class _SignInBody extends StatefulWidget {
  final _SignInLayout layout;

  const _SignInBody({required this.layout});

  @override
  State<_SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<_SignInBody> {
  bool _obscureText = true;
  bool _loading = false;
  String? _error;

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _setError(String? message) {
    if (!mounted) return;
    setState(() => _error = message);
  }

  void _showErrorSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  bool _validate() {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    if (email.isEmpty) {
      _setError('Введите email');
      _showErrorSnack('Введите email');
      return false;
    }
    // Базовая проверка, чтобы не тащить RegExp/валидаторы внутрь твоих ActionEditLine.
    if (!email.contains('@') || !email.contains('.')) {
      _setError('Неверный формат email');
      _showErrorSnack('Неверный формат email');
      return false;
    }
    if (pass.isEmpty) {
      _setError('Введите пароль');
      _showErrorSnack('Введите пароль');
      return false;
    }
    if (pass.length < 6) {
      _setError('Пароль должен быть минимум 6 символов');
      _showErrorSnack('Пароль должен быть минимум 6 символов');
      return false;
    }

    _setError(null);
    return true;
  }

  Future<void> _signIn() async {
    if (_loading) return;
    if (!_validate()) return;

    setState(() => _loading = true);

    try {
      await supabase.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      ); // [web:4]

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on AuthException catch (e) {
      _setError(e.message);
      _showErrorSnack(e.message);
    } catch (_) {
      _setError('Ошибка входа');
      _showErrorSnack('Ошибка входа');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildModalContent() {
    return ActionModal(
      label: _loading ? "..." : "Войти",
      onPressed: _loading ? null : _signIn,
      children: [
        SizedBox(height: 38.h),
        const ActionHeading(text: "Добро пожаловать"),
        SizedBox(height: 45.h),

        ActionEditLine(
          label: "Логин (email)",
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: 20.h),

        ActionEditLine(
          label: "Пароль",
          controller: _passCtrl,
          keyboardType: TextInputType.visiblePassword,
          obscureText: _obscureText,
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() => _obscureText = !_obscureText);
            },
          ),
        ),

        if (_error != null) ...[
          SizedBox(height: 14.h),
          Text(
            _error!,
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 12.sp,
            ),
          ),
        ],

        SizedBox(height: 40.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: null, // TODO: OAuth Google
              child: Image.asset(
                "assets/icons/google.png",
                width: 40.w,
                height: 40.h,
              ),
            ),
            SizedBox(width: 20.w),
            GestureDetector(
              onTap: null, // TODO: OAuth VK
              child: Image.asset(
                "assets/icons/vk.png",
                width: 40.w,
                height: 40.h,
              ),
            ),
            SizedBox(width: 20.w),
            GestureDetector(
              onTap: null, // TODO: OAuth Yandex
              child: Image.asset(
                "assets/icons/yandex.png",
                width: 40.w,
                height: 40.h,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHorizontal = widget.layout == _SignInLayout.horizontal;

    return Scaffold(
      body: Stack(
        children: [
          // Фон на весь экран через Stack + Positioned.fill. [web:6]
          Positioned.fill(
            child: Image.asset(
              'assets/images/start_wallpaper.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Center(
              child: isHorizontal
                  ? ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 520.w),
                      child: _buildModalContent(),
                    )
                  : _buildModalContent(),
            ),
          ),
        ],
      ),
    );
  }
}
