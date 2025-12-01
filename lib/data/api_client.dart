import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio dio;

  ApiClient._(this.dio);

  factory ApiClient({required String baseUrl, String? bearerToken}) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // АВТОМАТИЧЕСКИ достаем токен перед каждым запросом
        // (для оптимизации можно кэшировать в переменную памяти)
        const storage = FlutterSecureStorage();
        final token = await storage.read(key: 'jwt_token');
        
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        return handler.next(options);
      },
      onError: (e, handler) {
         // Если 401 - можно тут же попробовать обновить токен
         return handler.next(e);
      }
    ));

    return ApiClient._(dio);
  }
}

