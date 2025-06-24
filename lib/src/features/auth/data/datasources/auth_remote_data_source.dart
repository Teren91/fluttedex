import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String email, String password);
  Future<void> register(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        return response.data['token'];
      }
      throw DioException(requestOptions: response.requestOptions, message: 'Login failed');
    } on DioException {
      // Re-throw la excepción para que sea manejada en capas superiores
      rethrow;
    }
  }

  @override
  Future<void> register(String email, String password) async {
    try {
      await dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
        },
      );
    } on DioException {
      rethrow;
    }
  }
}
