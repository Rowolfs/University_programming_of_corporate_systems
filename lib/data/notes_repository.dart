import '../models/note.dart';
import 'api_client.dart';

class NotesRepository {
  final ApiClient _client;
  NotesRepository(this._client);

  // --- Получение списка ---
  Future<List<Note>> list({int page = 1, int limit = 20}) async {
    final resp = await _client.dio.get(
      '/notes',
      // API может игнорировать пагинацию, но параметры передаем
      queryParameters: {'page': page, 'limit': limit}, 
    );

    final body = resp.data as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    
    return data.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
  }

  // --- Получение одной заметки ---
  Future<Note> get(String noteId) async {
    final resp = await _client.dio.get('/notes/$noteId');
    final body = resp.data as Map<String, dynamic>;
    final noteJson = body['data'] as Map<String, dynamic>; 
    return Note.fromJson(noteJson);
  }

  // --- Создание ---
  Future<Note> create(String title, String body) async {
    final resp = await _client.dio.post('/notes', data: {
      'title': title,
      'body': body,
    });

    final responseBody = resp.data as Map<String, dynamic>;
    return Note.fromJson(responseBody['data'] as Map<String, dynamic>);
  }

  // --- Удаление (исправил название dle -> delete) ---
  Future<void> delete(String noteId) async {
    // Для удаления обычно возвращается просто сообщение, парсить Note не нужно
    await _client.dio.delete('/notes/$noteId');
  }

  // --- "Редактирование" (Workaround) ---
  Future<Note> update(String oldNoteId, String title, String body) async {
    // 1. Удаляем старую запись
    await delete(oldNoteId);
    
    // 2. Создаем новую с теми же данными (но новым ID)
    // Небольшая пауза для надежности (необязательно, но API может тупить)
    await Future.delayed(const Duration(milliseconds: 300));
    
    return await create(title, body);
  }
}
