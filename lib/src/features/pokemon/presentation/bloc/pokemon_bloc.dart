import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_event.dart';
import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon_detail.dart';
import 'package:fluttedex/src/features/pokemon/domain/usecases/get_pokemon_by_name.dart';
import 'package:fluttedex/src/features/pokemon/domain/usecases/get_pokemon_detail.dart';
import 'package:fluttedex/src/features/pokemon/domain/usecases/get_pokemons.dart'; 

// Estados adicionales para el detalle del Pokémon
class PokemonDetailLoading extends PokemonState {
  @override
  List<Object> get props => [];
}

class PokemonDetailLoaded extends PokemonState {
  final PokemonDetail pokemon;

  const PokemonDetailLoaded({required this.pokemon});

  @override
  List<Object> get props => [pokemon];
}

class PokemonDetailError extends PokemonState {
  final String message;

  const PokemonDetailError({required this.message});

  @override
  List<Object> get props => [message];
}

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetPokemons getPokemons;
  final GetPokemonByName getPokemonByName;
  final GetPokemonDetail getPokemonDetail;

  PokemonBloc({
    required this.getPokemons, 
    required this.getPokemonByName,
    required this.getPokemonDetail,
  }) : super(PokemonInitial()) {
    on<FetchPokemons>(_onFetchPokemons);
    on<SearchPokemon>(_onSearchPokemon);
    on<FetchPokemonDetail>(_onFetchPokemonDetail);
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

  void _onFetchPokemonDetail(FetchPokemonDetail event, Emitter<PokemonState> emit) async {
    emit(PokemonDetailLoading());
    try {
      final pokemon = await getPokemonDetail(event.nameOrId);
      emit(PokemonDetailLoaded(pokemon: pokemon));
    } catch (e) {
      emit(PokemonDetailError(message: e.toString()));
    }
  }
}
