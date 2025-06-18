import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon.dart';
import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon_detail.dart';

abstract class PokemonRepository {
  Future<List<Pokemon>> getPokemons();
  Future<Pokemon> getPokemonByName(String name);
  Future<PokemonDetail> getPokemonDetail(String nameOrId);
}
