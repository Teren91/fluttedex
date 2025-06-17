import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon.dart';
import 'package:fluttedex/src/features/pokemon/domain/repositories/pokemon_repository.dart';

class GetPokemons {
  final PokemonRepository repository;

  GetPokemons(this.repository);

  Future<List<Pokemon>> call() async {
    return await repository.getPokemons();
  }
}
