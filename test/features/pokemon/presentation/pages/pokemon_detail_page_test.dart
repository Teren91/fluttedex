import 'package:bloc_test/bloc_test.dart';
import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon_detail.dart';
import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon_stat.dart';
import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon_type.dart';
import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_bloc.dart';
import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_event.dart';
import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_state.dart';
import 'package:fluttedex/src/features/pokemon/presentation/pages/pokemon_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class MockPokemonBloc extends MockBloc<PokemonEvent, PokemonState>
    implements PokemonBloc {}

void main() {
  late MockPokemonBloc mockPokemonBloc;

  const mockPokemonDetail = PokemonDetail(
    id: 1,
    name: 'Arcanine',
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/59.png',
    description: 'A powerful fire-type Pokemon',
    height: 180,
    weight: 90,
    stats: [
      PokemonStat(name: 'hp', baseStat: 78, effort: 0),
      PokemonStat(name: 'attack', baseStat: 84, effort: 0),
      PokemonStat(name: 'defense', baseStat: 78, effort: 0),
      PokemonStat(name: 'special-attack', baseStat: 100, effort: 0),
      PokemonStat(name: 'special-defense', baseStat: 80, effort: 0),
      PokemonStat(name: 'speed', baseStat: 80, effort: 0),
    ],
    types: [PokemonType(name: 'fire', url: '')],
  );

  setUp(() {
    mockPokemonBloc = MockPokemonBloc();
  });

  testWidgets(
      'PokemonDetailPage should display PokemonDetail when state is loaded',
      (tester) async {
    whenListen(
      mockPokemonBloc,
      Stream.fromIterable(
          [const PokemonDetailLoaded(pokemon: mockPokemonDetail)]),
      initialState: const PokemonDetailLoaded(pokemon: mockPokemonDetail),
    );

    await tester.pumpWidget(BlocProvider<PokemonBloc>.value(
      value: mockPokemonBloc,
      child: const MaterialApp(
        home: PokemonDetailPage(nameOrId: 'arcanine'),
      ),
    ));

    final appBarFinder = find.widgetWithText(AppBar, 'Arcanine');
    expect(appBarFinder, findsOneWidget);
  });
}
