import 'package:flutter/material.dart';
import '../data/notes_repository.dart';

class NoteAddPage extends StatefulWidget {
  final NotesRepository repo;
  const NoteAddPage({super.key, required this.repo});

  @override
  State<NoteAddPage> createState() => _NoteAddPageState();
}

class _NoteAddPageState extends State<NoteAddPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните заголовок и текст')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Вызываем метод создания в репозитории
      await widget.repo.create(title, body);
      
      if (!mounted) return;
      
      // Возвращаемся назад с результатом "true" (чтобы обновить список)
      Navigator.pop(context, true); 
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая заметка'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isLoading ? null : _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Заголовок',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: 'Текст заметки',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5, // Многострочное поле
            ),
            if (_isLoading) ...[
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ]
          ],
        ),
      ),
    );
  }
}
