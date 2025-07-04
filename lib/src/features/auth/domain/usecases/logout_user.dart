import 'package:fluttedex/src/features/auth/domain/repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository repository;

  LogoutUser(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
