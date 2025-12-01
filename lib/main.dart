import 'package:flutter/material.dart';
import 'pages/notes_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';


void main() => runApp(const ApiNotesApp());

class ApiNotesApp extends StatelessWidget {
  const ApiNotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
      '/login': (context) => const LoginPage(),
      '/register': (context) => const RegisterPage(), // Ваша страница регистрации
      '/home': (context) => const NotesPage(), // Ваша главная страница
      },
      title: 'API Notes',
      theme: ThemeData(useMaterial3: true),
    );
  }
}
