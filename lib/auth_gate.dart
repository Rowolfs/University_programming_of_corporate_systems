import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:notes_list_example/notes_page.dart';



class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true;
  bool isLoading = false;

  Future<void> _auth() async {
    setState(() => isLoading = true);
    try {
  final supabase = Supabase.instance.client;

  if (isLogin) {
    final response = await supabase.auth.signInWithPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    final user = response.user; // вот так получаем пользователя напрямую
    if (user != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NotesPage(userId: user.id)),
      );
    }

  } else {
    final response = await supabase.auth.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    final user = response.user;
    if (user != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NotesPage(userId: user.id)),
      );
    }
  }
} on AuthException catch (e) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Ошибка: ${e.message}')));
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Вход' : 'Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _auth,
                      child: Text(isLogin ? 'Войти' : 'Зарегистрироваться'),
                    ),
              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(isLogin
                    ? 'Нет аккаунта? Зарегистрироваться'
                    : 'Уже есть аккаунт? Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

