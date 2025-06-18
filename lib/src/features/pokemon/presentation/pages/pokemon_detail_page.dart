import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_bloc.dart';
import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_event.dart';
import 'package:fluttedex/src/features/pokemon/presentation/bloc/pokemon_state.dart';
import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon_detail.dart';
import 'package:fluttedex/src/features/pokemon/domain/entities/pokemon_stat.dart';

class PokemonDetailPage extends StatefulWidget {
  final String nameOrId;

  const PokemonDetailPage({super.key, required this.nameOrId});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late final PokemonBloc _pokemonBloc;

  @override
  void initState() {
    super.initState();
    _pokemonBloc = context.read<PokemonBloc>();
    _pokemonBloc.add(FetchPokemonDetail(nameOrId: widget.nameOrId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      bloc: _pokemonBloc,
      builder: (context, state) {
        if (state is PokemonDetailLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is PokemonDetailError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: ${state.message}')),
          );
        } else if (state is PokemonDetailLoaded) {
          return _PokemonDetailView(pokemon: state.pokemon);
        } else {
          return const Scaffold(
            body: Center(child: Text('Unexpected state')),
          );
        }
      },
    );
  }
}

class _PokemonDetailView extends StatelessWidget {
  final PokemonDetail pokemon;

  const _PokemonDetailView({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getTypeColor(
              pokemon.types.isNotEmpty ? pokemon.types.first.name : 'normal')
          .withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: _getTypeColor(
            pokemon.types.isNotEmpty ? pokemon.types.first.name : 'normal'),
        title: Text(
          '${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pokemon Image
            Center(
              child: Hero(
                tag: 'pokemon-${pokemon.id}',
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  height: 200,
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),

            // Pokemon Info Card
            _buildInfoCard(context),

            // Stats Section
            _buildStatsSection(context),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name and ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Types
            Wrap(
              spacing: 8.0,
              children: pokemon.types
                  .map((type) => Chip(
                        label: Text(
                          type.name.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                        backgroundColor: _getTypeColor(type.name),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              pokemon.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 16),

            // Height and Weight
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumn('Height', '${pokemon.height / 10} m'),
                _buildInfoColumn('Weight', '${pokemon.weight / 10} kg'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Base Stats',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...pokemon.stats.map((stat) => _buildStatBar(stat, context)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar(PokemonStat stat, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${stat.name[0].toUpperCase()}${stat.name.substring(1).replaceAll('-', ' ')}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                '${stat.baseStat}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: stat.baseStat / 200, // Assuming max stat is 200 for scaling
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getTypeColor(pokemon.types.isNotEmpty
                  ? pokemon.types.first.name
                  : 'normal'),
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'normal':
        return const Color(0xFFA8A77A);
      case 'fire':
        return const Color(0xFFEE8130);
      case 'water':
        return const Color(0xFF6390F0);
      case 'electric':
        return const Color(0xFFF7D02C);
      case 'grass':
        return const Color(0xFF7AC74C);
      case 'ice':
        return const Color(0xFF96D9D6);
      case 'fighting':
        return const Color(0xFFC22E28);
      case 'poison':
        return const Color(0xFFA33EA1);
      case 'ground':
        return const Color(0xFFE2BF65);
      case 'flying':
        return const Color(0xFFA98FF3);
      case 'psychic':
        return const Color(0xFFF95587);
      case 'bug':
        return const Color(0xFFA6B91A);
      case 'rock':
        return const Color(0xFFB6A136);
      case 'ghost':
        return const Color(0xFF735797);
      case 'dragon':
        return const Color(0xFF6F35FC);
      case 'dark':
        return const Color(0xFF705746);
      case 'steel':
        return const Color(0xFFB7B7CE);
      case 'fairy':
        return const Color(0xFFD685AD);
      default:
        return const Color(0xFF777777);
    }
  }
}
