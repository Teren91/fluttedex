import 'package:equatable/equatable.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object> get props => [];
}

class FetchPokemons extends PokemonEvent {}

class SearchPokemon extends PokemonEvent {
  final String name;

  const SearchPokemon({required this.name});

  @override
  List<Object> get props => [name];
}

class FetchPokemonDetail extends PokemonEvent {
  final String nameOrId;

  const FetchPokemonDetail({required this.nameOrId});

  @override
  List<Object> get props => [nameOrId];
}
