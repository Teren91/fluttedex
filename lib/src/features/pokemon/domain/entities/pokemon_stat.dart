import 'package:equatable/equatable.dart';

class PokemonStat extends Equatable {
  final String name;
  final int baseStat;
  final int effort;

  const PokemonStat({
    required this.name,
    required this.baseStat,
    required this.effort,
  });

  @override
  List<Object?> get props => [name, baseStat, effort];
}
