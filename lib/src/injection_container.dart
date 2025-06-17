import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:fluttedex/src/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:fluttedex/src/features/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'package:fluttedex/src/features/pokemon/domain/usecases/get_pokemons.dart';
import 'package:fluttedex/src/features/pokemon/domain/usecases/get_pokemon_by_name.dart';
import 'package:fluttedex/src/features/pokemon/data/datasources/pokemon_remote_data_source.dart';
import 'package:dio/dio.dart';

// Instancia global de GetIt
final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio Client
  getIt.registerSingleton<Dio>(Dio());

  // Dependencies
  getIt.registerSingleton<PokemonRemoteDataSource>(
    PokemonRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  getIt.registerSingleton<PokemonRepository>(
    PokemonRepositoryImpl(remoteDataSource: getIt<PokemonRemoteDataSource>()),
  );

  // Use cases
  getIt.registerSingleton<GetPokemons>(
    GetPokemons(getIt<PokemonRepository>()),
  );

  getIt.registerSingleton<GetPokemonByName>(
    GetPokemonByName(getIt<PokemonRepository>()),
  );

  // Bloc
  getIt.registerFactory<PokemonBloc>(
    () => PokemonBloc(
      getPokemons: getIt<GetPokemons>(),
      getPokemonByName: getIt<GetPokemonByName>(),
    ),
  );
}
