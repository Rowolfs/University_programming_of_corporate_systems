import 'package:flutter/material.dart';
import 'pages/notes_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main(){
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const NotesApp());
  
  }

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes SQLite',
      theme: ThemeData(useMaterial3: true),
      home: const NotesPage(),
    );
  }
}
