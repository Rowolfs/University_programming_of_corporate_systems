import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client.dart'; // Импорт вашего файла с ApiClient

class AuthRepository {
  final String baseUrl;
  final FlutterSecureStorage _storage;
  

  AuthRepository({
    
    required this.baseUrl, 

  }) : _storage = const FlutterSecureStorage();

  /// Метод регистрации
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Создаем клиент БЕЗ токена, так как для регистрации он не нужен
    final client = ApiClient(baseUrl: baseUrl);

    try {
      final response = await client.dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      // Dio обычно кидает ошибку, если статус не 200, но проверим тело ответа
      // согласно вашей спецификации: "status": "success"
      final data = response.data;
      return data['status'] == 'success';

    } on DioException catch (e) {
      // Обработка ошибок от сервера (например, 400 Bad Request, если email занят)
      return _handleDioError(e);
    } catch (e) {
      print('Unknown error: $e');
      return false;
    }
  }

  /// Метод авторизации
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final client = ApiClient(baseUrl: baseUrl);

    try {
      final response = await client.dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      
      // Парсим ответ согласно скриншоту
      if (data['status'] == 'success' && data['data'] != null) {
        final token = data['data']['accessToken'];
        
        // Сохраняем токен в безопасное хранилище
        await _storage.write(key: 'jwt_token', value: token);
        
        return token;
      }
      return null;

    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      print('Unknown error: $e');
      return null;
    }
  }

  /// Выход из системы
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  /// Хелпер для логирования ошибок Dio
  bool _handleDioError(DioException e) {
    if (e.response != null) {
      print('Dio Error Status: ${e.response?.statusCode}');
      print('Dio Error Data: ${e.response?.data}');
      // Тут можно парсить сообщение об ошибке от сервера
    } else {
      print('Dio Error Message: ${e.message}');
    }
    return false;
  }
}
