import 'package:dio/dio.dart';
import 'package:fluttedex/src/features/pokemon/data/models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  Future<List<PokemonModel>> getPokemons();
  Future<PokemonModel> getPokemonByName(String name);
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final Dio dio;

  PokemonRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PokemonModel>> getPokemons() async {
    final response =
        await dio.get('https://pokeapi.co/api/v2/pokemon?limit=151');
    if (response.statusCode == 200) {
      return (response.data['results'] as List)
          .map((e) => PokemonModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load pokemons');
    }
  }

  @override
  Future<PokemonModel> getPokemonByName(String name) async {
    final response = await dio.get('https://pokeapi.co/api/v2/pokemon/$name');
    if (response.statusCode == 200) {
      return PokemonModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load pokemon');
    }
  }
}
