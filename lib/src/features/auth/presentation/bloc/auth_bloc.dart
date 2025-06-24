import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttedex/src/features/auth/domain/usecases/check_auth_status.dart';
import 'package:fluttedex/src/features/auth/domain/usecases/login_user.dart';
import 'package:fluttedex/src/features/auth/domain/usecases/logout_user.dart';
import 'package:fluttedex/src/features/auth/domain/usecases/register_user.dart';
import 'package:fluttedex/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:fluttedex/src/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;
  final CheckAuthStatus checkAuthStatus;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    required this.logoutUser,
    required this.checkAuthStatus,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusRequested>(_onCheckAuthStatusRequested);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatusRequested(
      CheckAuthStatusRequested event, Emitter<AuthState> emit) async {
    try {
      final isAuthenticated = await checkAuthStatus();
      if (isAuthenticated) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await loginUser(event.email, event.password);
      emit(Authenticated());
    } catch (e) {
      emit(const AuthFailure(
          message: 'Login failed. Please check your credentials.'));
    }
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await registerUser(event.email, event.password);
      // Después de registrar, intentamos hacer login directamente
      await loginUser(event.email, event.password);
      emit(Authenticated());
    } catch (e) {
      emit(
          const AuthFailure(message: 'Registration failed. Please try again.'));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    await logoutUser();
    emit(Unauthenticated());
  }
}
