import 'package:fluttedex/src/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<void> call(String email, String password) {
    return repository.login(email, password);
  }
}
