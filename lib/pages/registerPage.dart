import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:tier_list_app/pages/homePage.dart';
import 'package:tier_list_app/services/supabase_client.dart';
import 'package:tier_list_app/widgets/actionModal.dart';
import 'package:tier_list_app/widgets/actionEditLine.dart';
import 'package:tier_list_app/widgets/actionHeading.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return isLandscape
        ? const RegisterPageHorizontal()
        : const RegisterPageVertical();
  }
}

class RegisterPageHorizontal extends StatelessWidget {
  const RegisterPageHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RegisterBody(layout: _RegisterLayout.horizontal);
  }
}

class RegisterPageVertical extends StatelessWidget {
  const RegisterPageVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RegisterBody(layout: _RegisterLayout.vertical);
  }
}

enum _RegisterLayout { vertical, horizontal }

class _RegisterBody extends StatefulWidget {
  final _RegisterLayout layout;

  const _RegisterBody({required this.layout});

  @override
  State<_RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<_RegisterBody> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  bool _loading = false;
  String? _error;

  final _emailCtrl = TextEditingController();
  final _pass1Ctrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pass1Ctrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  void _setError(String? message) {
    if (!mounted) return;
    setState(() => _error = message);
  }

  void _showSnack(String message, {Color? color}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  bool _validate() {
    final email = _emailCtrl.text.trim();
    final pass1 = _pass1Ctrl.text;
    final pass2 = _pass2Ctrl.text;

    if (email.isEmpty) {
      _setError('Введите email');
      _showSnack('Введите email', color: Colors.redAccent);
      return false;
    }
    if (!email.contains('@') || !email.contains('.')) {
      _setError('Неверный формат email');
      _showSnack('Неверный формат email', color: Colors.redAccent);
      return false;
    }
    if (pass1.isEmpty) {
      _setError('Введите пароль');
      _showSnack('Введите пароль', color: Colors.redAccent);
      return false;
    }
    if (pass1.length < 6) {
      _setError('Пароль должен быть минимум 6 символов');
      _showSnack('Пароль должен быть минимум 6 символов', color: Colors.redAccent);
      return false;
    }
    if (pass1 != pass2) {
      _setError('Пароли не совпадают');
      _showSnack('Пароли не совпадают', color: Colors.redAccent);
      return false;
    }

    _setError(null);
    return true;
  }

  Future<void> _signUp() async {
    if (_loading) return;
    if (!_validate()) return;

    setState(() => _loading = true);

    try {
      final email = _emailCtrl.text.trim();
      final pass1 = _pass1Ctrl.text;

      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: pass1,
      );

      if (!mounted) return;

      // В Supabase при включённом подтверждении email session может быть null — это нормальный сценарий.
      if (res.session == null) {
        _showSnack(
          'Аккаунт создан. Проверьте почту и подтвердите email, затем войдите.',
          color: Colors.blueGrey,
        );
        // Обычно после этого возвращают на экран входа:
        Navigator.pop(context);
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on AuthException catch (e) {
      _setError(e.message);
      _showSnack(e.message, color: Colors.redAccent);
    } catch (_) {
      _setError('Ошибка регистрации');
      _showSnack('Ошибка регистрации', color: Colors.redAccent);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildModal() {
    return ActionModal(
      label: _loading ? "..." : "Зарегистрироваться",
      onPressed: _loading ? null : _signUp,
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
          controller: _pass1Ctrl,
          obscureText: _obscureText1,
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscureText1 = !_obscureText1),
            icon: Icon(_obscureText1 ? Icons.visibility_off : Icons.visibility),
          ),
        ),

        SizedBox(height: 20.h),

        ActionEditLine(
          label: "Пароль ещё раз",
          controller: _pass2Ctrl,
          obscureText: _obscureText2,
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscureText2 = !_obscureText2),
            icon: Icon(_obscureText2 ? Icons.visibility_off : Icons.visibility),
          ),
        ),

        if (_error != null) ...[
          SizedBox(height: 14.h),
          Text(
            _error!,
            style: TextStyle(color: Colors.redAccent, fontSize: 12.sp),
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
    final isHorizontal = widget.layout == _RegisterLayout.horizontal;

    return Scaffold(
      body: Stack(
        children: [
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
                      constraints: BoxConstraints(maxWidth: 560.w),
                      child: _buildModal(),
                    )
                  : _buildModal(),
            ),
          ),
        ],
      ),
    );
  }
}
