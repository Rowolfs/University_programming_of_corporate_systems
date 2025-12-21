import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tier_list_app/pages/signInPage.dart';
import 'package:tier_list_app/pages/RegisterPage.dart';
import 'package:tier_list_app/widgets/actionButton.dart';

// ВАЖНО: импортни свой supabase_client.dart, где у тебя Supabase.instance.client
import 'package:tier_list_app/services/supabase_client.dart';

// Импортни главную страницу (поменяй путь если другой)
import 'package:tier_list_app/pages/homePage.dart';

class GreetingsPage extends StatefulWidget {
  const GreetingsPage({super.key});

  @override
  State<GreetingsPage> createState() => _GreetingsPageState();
}

class _GreetingsPageState extends State<GreetingsPage> {
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _redirectIfLoggedIn();
  }

  Future<void> _redirectIfLoggedIn() async {
    // чтобы не пушить экран во время build
    await Future.delayed(Duration.zero);

    if (!mounted) return;

    final session = supabase.auth.currentSession; // [web:201]
    if (session != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
      return;
    }

    setState(() => _checked = true);
  }

  @override
  Widget build(BuildContext context) {
    // Пока проверяем сессию — можно показать пустой экран/лоадер
    if (!_checked) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return isLandscape
        ? const GreetingsPageHorizontal()
        : const GreetingsPageVertical();
  }
}

class GreetingsPageVertical extends StatelessWidget {
  const GreetingsPageVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 1,
            child: Image.asset(
              'assets/images/start_wallpaper.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              const SizedBox(height: 138),
              SvgPicture.asset(
                "assets/vectors/Tierly.svg",
                width: 266,
                height: 94,
              ),
              const SizedBox(height: 149),
              ActionButton(
                label: "Войти",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                ),
              ),
              const SizedBox(height: 30),
              ActionButton(
                label: "Регистрация",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GreetingsPageHorizontal extends StatelessWidget {
  const GreetingsPageHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("THIS IS horizontal"));
  }
}
