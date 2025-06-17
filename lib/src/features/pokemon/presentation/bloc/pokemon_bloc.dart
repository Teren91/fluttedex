import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_event.dart';
import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttedex/src/features/pokemon/domain/usecases/get_pokemon_by_name.dart';
import 'package:fluttedex/src/features/pokemon/domain/usecases/get_pokemons.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetPokemons getPokemons;
  final GetPokemonByName getPokemonByName;

  PokemonBloc({required this.getPokemons, required this.getPokemonByName})
      : super(PokemonInitial()) {
    on<FetchPokemons>(_onFetchPokemons);
    on<SearchPokemon>(_onSearchPokemon);
  }

  void _onFetchPokemons(FetchPokemons event, Emitter<PokemonState> emit) async {
    emit(PokemonLoading());
    try {
      final pokemons = await getPokemons();
      emit(PokemonLoaded(pokemons: pokemons));
    } catch (e) {
      emit(PokemonError(message: e.toString()));
    }
  }

  void _onSearchPokemon(SearchPokemon event, Emitter<PokemonState> emit) async {
    emit(PokemonLoading());
    try {
      final pokemon = await getPokemonByName(event.name.toLowerCase());
      emit(PokemonLoaded(pokemons: [pokemon]));
    } catch (e) {
      emit(PokemonError(message: e.toString()));
    }
  }
}
