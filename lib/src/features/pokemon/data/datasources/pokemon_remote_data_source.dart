import 'package:dio/dio.dart';
import 'package:fluttedex/src/features/pokemon/data/models/pokemon_model.dart';
import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon_detail.dart';
import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon_type.dart';
import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon_stat.dart';

abstract class PokemonRemoteDataSource {
  Future<List<PokemonModel>> getPokemons();
  Future<PokemonModel> getPokemonByName(String name);
  Future<PokemonDetail> getPokemonDetail(String nameOrId);
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

  @override
  Future<PokemonDetail> getPokemonDetail(String nameOrId) async {
    try {
      // Fetch basic pokemon data
      final pokemonResponse = await dio.get('https://pokeapi.co/api/v2/pokemon/$nameOrId');
      
      if (pokemonResponse.statusCode != 200) {
        throw Exception('Failed to load pokemon details');
      }

      // Fetch species data for description
      final speciesResponse = await dio.get('https://pokeapi.co/api/v2/pokemon-species/$nameOrId');
      
      if (speciesResponse.statusCode != 200) {
        throw Exception('Failed to load pokemon species data');
      }

      final pokemonData = pokemonResponse.data;
      final speciesData = speciesResponse.data;

      // Get English description
      String description = 'No description available';
      final flavorTextEntries = List<Map<String, dynamic>>.from(speciesData['flavor_text_entries']);
      final englishEntry = flavorTextEntries.firstWhere(
        (entry) => entry['language']['name'] == 'en',
        orElse: () => {},
      );
      
      if (englishEntry.isNotEmpty) {
        description = englishEntry['flavor_text']
            .replaceAll('\n', ' ')
            .replaceAll('\f', ' ')
            .replaceAll('  ', ' ');
      }

      // Map types
      final types = (pokemonData['types'] as List).map((typeData) {
        return PokemonType(
          name: typeData['type']['name'],
          url: typeData['type']['url'],
        );
      }).toList();

      // Map stats
      final stats = (pokemonData['stats'] as List).map((statData) {
        return PokemonStat(
          name: statData['stat']['name'],
          baseStat: statData['base_stat'],
          effort: statData['effort'],
        );
      }).toList();

      return PokemonDetail(
        id: pokemonData['id'],
        name: pokemonData['name'],
        imageUrl: pokemonData['sprites']['other']['official-artwork']['front_default'] ??
                 pokemonData['sprites']['front_default'],
        height: pokemonData['height'],
        weight: pokemonData['weight'],
        types: types,
        stats: stats,
        description: description,
      );
    } catch (e) {
      throw Exception('Failed to load pokemon details: $e');
    }
  }
}
