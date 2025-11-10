import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:notes_list_example/auth_gate.dart';

const supabaseUrl = 'https://ihrmlsuobktlhhwtczvq.supabase.co';
const supabaseAnonKey = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(NotesApp());
}


class NotesApp extends StatelessWidget {
  const NotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Notes',
      theme: ThemeData(useMaterial3: true),
      home: const AuthGate(),
    );
  }
}

