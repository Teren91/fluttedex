import 'package:fluttedex/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluttedex/src/features/auth/presentation/pages/auth_wrapper_page.dart';
import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_event.dart';
import 'package:fluttedex/src/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_bloc.dart';

void main() async {
  // Asegurarse de que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar dependencias
  await di.initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PokemonBloc>(
          create: (context) => di.sl<PokemonBloc>()..add(FetchPokemons()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Fluttedex',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthWrapperPage(),
      ),
    );
  }
}
