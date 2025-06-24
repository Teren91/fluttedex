import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Rutas públicas que no requieren token
    final publicRoutes = [
      '/auth/login',
      '/auth/register',
    ];

    // Si la ruta es pública, continuamos la petición sin añadir el token
    if (publicRoutes.any((path) => options.path.endsWith(path))) {
      return handler.next(options);
    }

    // Para rutas protegidas, leemos el token y lo añadimos
    final token = await _secureStorage.read(key: 'jwt_token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }
}
