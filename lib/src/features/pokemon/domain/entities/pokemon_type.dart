import 'package:equatable/equatable.dart';

class PokemonType extends Equatable {
  final String name;
  final String url;

  const PokemonType({required this.name, required this.url});

  @override
  List<Object?> get props => [name, url];
}
