import 'package:flutter/material.dart';
import '../models/note.dart';
import '../data/api_client.dart';
import '../data/notes_repository.dart';
import 'note_details_page.dart';
import 'note_add_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final NotesRepository repo;
  final List<Note> _items = [];
  int _page = 1;
  bool _canLoadMore = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final client = ApiClient(baseUrl: 'https://notes-api.dicoding.dev/v1');
    repo = NotesRepository(client);
    // _refresh вызывать тут безопасно, т.к. он асинхронный и setState сработает уже после build
    _refresh();
  }

  Future<void> _refresh() async {
    // Сбрасываем состояние
    setState(() {
      _page = 1;
      _canLoadMore = true;
      _items.clear();
    });
    await _loadMore();
  }

  Future<void> _loadMore() async {
  // Если загружать больше нечего или уже идет загрузка - выходим
  if (!_canLoadMore || _loading) return;

  setState(() => _loading = true);

  try {
    final batch = await repo.list(page: _page, limit: 20);
    
    if (!mounted) return;
    
    setState(() {
      // 1. Находим только те заметки, которых еще нет в _items
      // (сравниваем по noteId)
      final newNotes = batch.where((noteFromApi) {
        return !_items.any((existingNote) => existingNote.noteId == noteFromApi.noteId);
      }).toList();

      // 2. Добавляем только новые
      _items.addAll(newNotes);

      // 3. Если новых заметок 0, значит мы загрузили всё
      if (newNotes.isEmpty) {
        _canLoadMore = false; 
      } else {
        // Если новые были - увеличиваем страницу
        _page++;
        
        // Доп. проверка: если пришло меньше, чем лимит (20), 
        // значит это была последняя страница
        if (batch.length < 20) {
          _canLoadMore = false;
        }
      }
    });
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: $e')),
      );
      // При ошибке можно остановить попытки загрузки, чтобы не спамить
      setState(() => _canLoadMore = false); 
    }
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Notes Feed')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // 1. Переходим на страницу создания и ждем результата
          // Мы используем generic тип <bool>, чтобы знать, сохранили ли что-то
          final bool? result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => NoteAddPage(repo: repo),
            ),
          );

          // 2. Если result == true (мы вернули true в Navigator.pop), обновляем список
          if (result == true) {
            _refresh();
          }
        },
      ),

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _items.isEmpty && _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _items.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  // Логика для "футера" списка
                  if (i == _items.length) {
                    if (_canLoadMore) {
                      // ИСПРАВЛЕНИЕ 2: Отложенный вызов загрузки!
                      // Оборачиваем _loadMore в addPostFrameCallback.
                      // Это гарантирует, что код выполнится ПОСЛЕ того, как Flutter закончит рисовать этот кадр.
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _loadMore();
                      });

                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }

                  final n = _items[i];
                  return Card(
                    child: ListTile(
                      title: Text(n.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(n.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => NoteDetailsPage(noteId: n.noteId, repo: repo)),
                        );
                        // Когда вернемся назад - обновляем список
                        _refresh();
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          final noteToDelete = _items[i];
                          setState(() => _items.removeAt(i));
                          await repo.delete(noteToDelete.noteId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Успешно удалено')),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
