import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_bloc.dart';
import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_event.dart';
import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_state.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  @override
  void initState() {
    super.initState();
    context.read<PokemonBloc>().add(FetchPokemons());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Recargar la lista de Pokémon
              context.read<PokemonBloc>().add(FetchPokemons());
            },
          ),
        ],
      ),
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state is PokemonLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PokemonLoaded) {
            if (state.pokemons.isEmpty) {
              return const Center(
                child: Text('No se encontraron Pokémon'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = state.pokemons[index];
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      pokemon.name.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Name: ${pokemon.name}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navegar al detalle del Pokémon
                      // Navigator.push(...);
                    },
                  ),
                );
              },
            );
          } else if (state is PokemonError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar los Pokémon',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Reintentar cargar los Pokémon
                      context.read<PokemonBloc>().add(FetchPokemons());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Estado inicial
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Cargando tu Pokédex...',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
