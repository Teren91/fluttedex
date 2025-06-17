import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon.dart';
import 'package:fluttedex/src/features/pokemon/domain/repositories/pokemon_repository.dart';

class GetPokemonByName {
  final PokemonRepository repository;

  GetPokemonByName(this.repository);

  Future<Pokemon> call(String name) async {
    return await repository.getPokemonByName(name);
  }
}
