import 'package:flutter/material.dart';
import '../data/auth_repository.dart'; 


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Ключ для валидации формы
  final _formKey = GlobalKey<FormState>();
  
  // Контроллеры для текстовых полей
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Состояние загрузки и видимости пароля
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // Экземпляр репозитория (лучше передавать через Provider/GetIt, но для примера создадим тут)
  // Убедитесь, что baseUrl совпадает с вашим ApiClient
  final _authRepository = AuthRepository(baseUrl: 'https://notes-api.dicoding.dev/v1');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // 1. Валидация полей
    if (!_formKey.currentState!.validate()) return;

    // 2. Включаем индикатор загрузки и прячем клавиатуру
    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      // 3. Вызов метода логина
      final token = await _authRepository.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (token != null) {
        // УСПЕХ: Переход на главный экран
        // pushReplacement убирает экран логина из стека назад
        Navigator.of(context).pushReplacementNamed('/home'); 
      } else {
        // ОШИБКА: Неверный логин/пароль (или другая ошибка API)
        _showError('Неверный email или пароль');
      }
    } catch (e) {
      _showError('Произошла ошибка соединения');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar можно убрать, если нужен полноэкранный дизайн
      appBar: AppBar(title: const Text('Вход в систему')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Логотип или заголовок
                const Text(
                  'Привет!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                // Поле Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите email';
                    }
                    // Простая проверка regex для email
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Некорректный формат email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Поле Пароль
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    // Кнопка "глаз"
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible 
                          ? Icons.visibility 
                          : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => _isPasswordVisible = !_isPasswordVisible);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Введите пароль';
                    if (value.length < 6) return 'Минимум 6 символов';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Кнопка Войти
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Войти', style: TextStyle(fontSize: 16)),
                  ),
                ),
                
                const SizedBox(height: 16),

                // Кнопка перехода к регистрации
                TextButton(
                  onPressed: () {
                    // Навигация на экран регистрации
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: const Text('Нет аккаунта? Зарегистрироваться'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
