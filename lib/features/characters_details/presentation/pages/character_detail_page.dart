import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart' as di;
import '../../../characters/domain/entities/character_model.dart';
import '../../../../core/utils/character_status_helper.dart';
import '../../../characters_episodes/presentation/widgets/episodes_list.dart';
import '../cubit/characters_details/characters_details_cubit.dart';
import '../cubit/characters_details/characters_details_state.dart';

class CharacterDetailPage extends StatelessWidget {
  const CharacterDetailPage({super.key, required this.characterId});

  final int characterId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          di.sl<CharacterDetailCubit>()..loadCharacterDetail(characterId),
      child: BlocListener<CharacterDetailCubit, CharacterDetailState>(
        listener: (context, state) {
          if (state is CharacterDetailError) {
            _onError(context, state.message);
          }
        },
        child: Scaffold(
          body: BlocBuilder<CharacterDetailCubit, CharacterDetailState>(
            builder: _buildBody,
          ),
        ),
      ),
    );
  }

  void _onError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () => context
              .read<CharacterDetailCubit>()
              .loadCharacterDetail(characterId),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CharacterDetailState state) {
    return switch (state) {
      CharacterDetailInitial() || CharacterDetailLoading() => const Center(
        child: CircularProgressIndicator(),
      ),
      CharacterDetailLoaded() => _buildLoaded(context, state.character),
      CharacterDetailError() => _buildError(context, state.message),
    };
  }

  Widget _buildError(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: colorScheme.error),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context
                .read<CharacterDetailCubit>()
                .loadCharacterDetail(characterId),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, CharacterModel character) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, character),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNameAndStatus(context, character),
                const SizedBox(height: 24),
                _buildInfoSection(context, character),
                const SizedBox(height: 24),
                _buildEpisodesSection(context, character),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, CharacterModel character) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      scrolledUnderElevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: character.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: colorScheme.surfaceContainerHighest,
                child: Center(
                  child: CircularProgressIndicator(color: colorScheme.primary),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: colorScheme.surfaceContainerHighest,
                child: Icon(Icons.person, size: 80, color: colorScheme.outline),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      colorScheme.surface,
                      colorScheme.surface.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameAndStatus(BuildContext context, CharacterModel character) {
    final colorScheme = Theme.of(context).colorScheme;
    final (statusColor, statusLabel) = CharacterStatusHelper.getStatusData(
      character.status,
      colorScheme,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          character.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '$statusLabel • ${character.species}',
              style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, CharacterModel character) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            icon: Icons.category_outlined,
            label: 'Type',
            value: character.type.isEmpty ? 'Unknown' : character.type,
          ),
          _buildDivider(colorScheme),
          _buildInfoRow(
            context,
            icon: Icons.wc_outlined,
            label: 'Gender',
            value: character.gender,
          ),
          _buildDivider(colorScheme),
          _buildInfoRow(
            context,
            icon: Icons.public_outlined,
            label: 'Origin',
            value: character.origin.name,
          ),
          _buildDivider(colorScheme),
          _buildInfoRow(
            context,
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: character.location.name,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: colorScheme.outlineVariant,
    );
  }

  Widget _buildEpisodesSection(BuildContext context, CharacterModel character) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Episodes',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${character.episode.length}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        EpisodesList(episodeUrls: character.episode),
      ],
    );
  }
}
