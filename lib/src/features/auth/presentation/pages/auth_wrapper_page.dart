import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttedex/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluttedex/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:fluttedex/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:fluttedex/src/features/auth/presentation/pages/login_page.dart';
import 'package:fluttedex/src/features/pokemon/presentation/pages/pokemon_list_page.dart';

class AuthWrapperPage extends StatefulWidget {
  const AuthWrapperPage({super.key});

  @override
  State<AuthWrapperPage> createState() => _AuthWrapperPageState();
}

class _AuthWrapperPageState extends State<AuthWrapperPage> {
  @override
  void initState() {
    super.initState();
    // Al iniciar, pedimos al BLoC que verifique el estado de autenticación
    context.read<AuthBloc>().add(CheckAuthStatusRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const PokemonListPage();
        }
        if (state is Unauthenticated || state is AuthFailure) {
          return const LoginPage();
        }
        // Mientras se verifica (AuthInitial, AuthLoading), mostramos un spinner
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
