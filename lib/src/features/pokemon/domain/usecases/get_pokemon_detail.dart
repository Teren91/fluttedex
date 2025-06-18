import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon_detail.dart';
import 'package:fluttedex/src/features/pokemon/domain/repositories/pokemon_repository.dart';

class GetPokemonDetail {
  final PokemonRepository repository;

  GetPokemonDetail(this.repository);

  Future<PokemonDetail> call(String nameOrId) async {
    return await repository.getPokemonDetail(nameOrId);
  }
}
