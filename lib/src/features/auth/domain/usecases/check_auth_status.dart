import 'package:fluttedex/src/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatus {
  final AuthRepository repository;

  CheckAuthStatus(this.repository);

  Future<bool> call() {
    return repository.isAuthenticated();
  }
}
