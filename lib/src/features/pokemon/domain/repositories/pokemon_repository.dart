import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon.dart';

abstract class PokemonRepository {
  Future<List<Pokemon>> getPokemons();
  Future<Pokemon> getPokemonByName(String name);
}
