import 'package:equatable/equatable.dart';
import 'pokemon_type.dart';
import 'pokemon_stat.dart';

class PokemonDetail extends Equatable {
  final int id;
  final String name;
  final String imageUrl;
  final int height;
  final int weight;
  final List<PokemonType> types;
  final List<PokemonStat> stats;
  final String description;

  const PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.types,
    required this.stats,
    required this.description,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        height,
        weight,
        types,
        stats,
        description,
      ];
}
