import 'package:flutter/material.dart';
import '../models/note.dart';
import '../data/notes_repository.dart';

class NoteDetailsPage extends StatefulWidget {
  // Делаем поле не final, так как ID может измениться
  final String initialNoteId; 
  final NotesRepository repo;
  
  const NoteDetailsPage({
    super.key, 
    required String noteId, // Принимаем как noteId
    required this.repo
  }) : initialNoteId = noteId;

  @override
  State<NoteDetailsPage> createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
  late String _currentId;
  late Future<Note> _noteFuture;

  @override
  void initState() {
    super.initState();
    _currentId = widget.initialNoteId;
    _loadNote();
  }

  void _loadNote() {
    setState(() {
      _noteFuture = widget.repo.get(_currentId);
    });
  }

  Future<void> _editNote(Note currentNote) async {
    final titleController = TextEditingController(text: currentNote.title);
    final bodyController = TextEditingController(text: currentNote.body);

    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Редактировать'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Заголовок'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Текст'),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Сохранить')),
        ],
      ),
    );

    if (shouldSave == true) {
      try {
        // Показываем загрузку
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Обновление (пересоздание)...')),
        );

        // Вызываем наш workaround update
        final newNote = await widget.repo.update(
          _currentId, 
          titleController.text, 
          bodyController.text
        );

        if (!mounted) return;

        setState(() {
          // ВАЖНО: Обновляем текущий ID на новый!
          _currentId = newNote.noteId;
          // Обновляем UI сразу новыми данными, чтобы не делать лишний GET запрос
          _noteFuture = Future.value(newNote);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Успешно обновлено!')),
        );

      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Note>(
      future: _noteFuture,
      builder: (context, snap) {
        if (snap.hasError) return Scaffold(appBar: AppBar(), body: Center(child: Text('Ошибка: ${snap.error}')));
        if (!snap.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));

        final n = snap.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text(n.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editNote(n),
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(n.body, style: const TextStyle(fontSize: 16)),
          ),
        );
      },
    );
  }
}
