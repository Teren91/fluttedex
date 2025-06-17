import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:fluttedex/src/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:fluttedex/src/features/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'package:fluttedex/src/features/pokemon/domain/usecases/get_pokemons.dart';
import 'package:fluttedex/src/features/pokemon/domain/usecases/get_pokemon_by_name.dart';
import 'package:fluttedex/src/features/pokemon/data/datasources/pokemon_remote_data_source.dart';
import 'package:dio/dio.dart';

// Instancia global de sl
final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // BLoC
  sl.registerFactory(
      () => PokemonBloc(getPokemons: sl(), getPokemonByName: sl()));

  // Casos de Uso
  sl.registerLazySingleton(() => GetPokemons(sl()));
  sl.registerLazySingleton(() => GetPokemonByName(sl()));

  // Repositorio
  sl.registerLazySingleton<PokemonRepository>(
      () => PokemonRepositoryImpl(remoteDataSource: sl()));

  // DataSource
  sl.registerLazySingleton<PokemonRemoteDataSource>(
      () => PokemonRemoteDataSourceImpl(dio: sl()));

  // Externo (Dio)
  sl.registerLazySingleton(() => Dio());
}
