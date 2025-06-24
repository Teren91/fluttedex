import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttedex/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fluttedex/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;
  static const _tokenKey = 'jwt_token';

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<void> login(String email, String password) async {
    final token = await remoteDataSource.login(email, password);
    await secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<void> register(String email, String password) async {
    await remoteDataSource.register(email, password);
  }

  @override
  Future<void> logout() async {
    await secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await secureStorage.read(key: _tokenKey);
    return token != null;
  }
}
