import 'package:fluttedex/src/features/pokemon/data/datasources/pokemon_remote_data_source.dart';
import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon.dart';
import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon_detail.dart';
import 'package:fluttedex/src/features/pokemon/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;

  PokemonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Pokemon>> getPokemons() async {
    try {
      return await remoteDataSource.getPokemons();
    } catch (e) {
      throw Exception('Failed to load pokemons');
    }
  }

  @override
  Future<Pokemon> getPokemonByName(String name) async {
    try {
      return await remoteDataSource.getPokemonByName(name);
    } catch (e) {
      throw Exception('Failed to load pokemon');
    }
  }

  @override
  Future<PokemonDetail> getPokemonDetail(String nameOrId) async {
    try {
      return await remoteDataSource.getPokemonDetail(nameOrId);
    } catch (e) {
      throw Exception('Failed to load pokemon details');
    }
  }
}
