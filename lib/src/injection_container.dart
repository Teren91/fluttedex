import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:fluttedex/src/core/constants/constants.dart';
import 'package:fluttedex/src/core/network/auth_interceptor.dart';

// Features
import 'package:fluttedex/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fluttedex/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fluttedex/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:fluttedex/src/features/auth/domain/usecases/check_auth_status.dart';
import 'package:fluttedex/src/features/auth/domain/usecases/login_user.dart';
import 'package:fluttedex/src/features/auth/domain/usecases/logout_user.dart';
import 'package:fluttedex/src/features/auth/domain/usecases/register_user.dart';
import 'package:fluttedex/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluttedex/src/features/pokemon/data/datasources/pokemon_remote_data_source.dart';
import 'package:fluttedex/src/features/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'package:fluttedex/src/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:fluttedex/src/features/pokemon/domain/usecases/get_pokemon_by_name.dart';
import 'package:fluttedex/src/features/pokemon/domain/usecases/get_pokemon_detail.dart';
import 'package:fluttedex/src/features/pokemon/domain/usecases/get_pokemons.dart';
import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // --- AUTH FEATURE ---
  // BLoC
  sl.registerFactory(() => AuthBloc(
        loginUser: sl(),
        registerUser: sl(),
        logoutUser: sl(),
        checkAuthStatus: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl(), secureStorage: sl()));

  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(dio: sl()));

  // --- POKEMON FEATURE ---
  // BLoC
  sl.registerFactory(() => PokemonBloc(
        getPokemons: sl(),
        getPokemonByName: sl(),
        getPokemonDetail: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => GetPokemons(sl()));
  sl.registerLazySingleton(() => GetPokemonByName(sl()));
  sl.registerLazySingleton(() => GetPokemonDetail(sl()));

  // Repository
  sl.registerLazySingleton<PokemonRepository>(
      () => PokemonRepositoryImpl(remoteDataSource: sl()));

  // Data Source
  sl.registerLazySingleton<PokemonRemoteDataSource>(
      () => PokemonRemoteDataSourceImpl(dio: sl()));

  // --- CORE & EXTERNAL ---
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => AuthInterceptor(sl()));
  sl.registerLazySingleton(() {
    final dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));
    dio.interceptors.add(sl<AuthInterceptor>());
    return dio;
  });
}

