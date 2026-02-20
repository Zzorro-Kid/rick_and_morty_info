import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../injection_container.dart' as di;
import '../../../../core/utils/navigation_helper.dart';
import '../../../characters/domain/entities/character_model.dart';
import '../cubit/episode_detail/episode_detail_cubit.dart';
import '../widgets/episode_code_badge.dart';
import '../widgets/episode_info_card.dart';
import '../widgets/episode_character_tile.dart';

class EpisodeDetailPage extends StatelessWidget {
  const EpisodeDetailPage({super.key, required this.episodeId});

  final int episodeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<EpisodeDetailCubit>()..loadEpisode(episodeId),
      child: Scaffold(
        body: BlocBuilder<EpisodeDetailCubit, EpisodeDetailState>(
          builder: _buildBody,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, EpisodeDetailState state) {
    return switch (state.status) {
      EpisodeDetailStatus.initial || EpisodeDetailStatus.loading =>
        const Center(child: CircularProgressIndicator()),
      EpisodeDetailStatus.failure => _buildError(context, state),
      EpisodeDetailStatus.success => _buildLoaded(context, state),
    };
  }

  Widget _buildError(BuildContext context, EpisodeDetailState state) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: colorScheme.error),
          const SizedBox(height: 12),
          Text(
            state.errorMessage ?? 'Something went wrong',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () =>
                context.read<EpisodeDetailCubit>().loadEpisode(episodeId),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, EpisodeDetailState state) {
    final episode = state.episode!;
    final colorScheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(colorScheme),
        SliverToBoxAdapter(
          child: _buildLoadedContent(context, episode, state, colorScheme),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(ColorScheme colorScheme) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      scrolledUnderElevation: 0,
      expandedHeight: 160,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildAppBarBackground(colorScheme),
      ),
    );
  }

  Widget _buildAppBarBackground(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        ),
      ),
      child: Center(child: _buildAppBarIcon(colorScheme)),
    );
  }

  Widget _buildAppBarIcon(ColorScheme colorScheme) {
    return Icon(
      Icons.movie_outlined,
      size: 72,
      color: colorScheme.onPrimaryContainer.withOpacity(0.4),
    );
  }

  Widget _buildLoadedContent(
    BuildContext context,
    dynamic episode,
    EpisodeDetailState state,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EpisodeCodeBadge(code: episode.episode),
          const SizedBox(height: 8),
          Text(
            episode.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          EpisodeInfoCard(airDate: episode.airDate),
          const SizedBox(height: 24),
          _buildCharactersSection(context, state, colorScheme),
        ],
      ),
    );
  }

  Widget _buildEpisodeCode(BuildContext context, String code) {
    return EpisodeCodeBadge(code: code);
  }

  Widget _buildInfoCard(BuildContext context, String airDate) {
    return EpisodeInfoCard(airDate: airDate);
  }

  Widget _buildCharactersSection(
    BuildContext context,
    EpisodeDetailState state,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Characters',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            if (state.charactersStatus == EpisodeDetailCharactersStatus.success)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${state.characters.length}',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        _buildCharactersBody(context, state, colorScheme),
      ],
    );
  }

  Widget _buildCharactersBody(
    BuildContext context,
    EpisodeDetailState state,
    ColorScheme colorScheme,
  ) {
    return switch (state.charactersStatus) {
      EpisodeDetailCharactersStatus.initial ||
      EpisodeDetailCharactersStatus.loading => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      EpisodeDetailCharactersStatus.failure => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          state.errorMessage ?? 'Failed to load characters',
          style: TextStyle(color: colorScheme.error),
        ),
      ),
      EpisodeDetailCharactersStatus.success => _buildCharactersList(
        context,
        state.characters,
        colorScheme,
      ),
    };
  }

  Widget _buildCharactersList(
    BuildContext context,
    List<CharacterModel> characters,
    ColorScheme colorScheme,
  ) {
    if (characters.isEmpty) {
      return const Center(child: Text('No characters'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: characters.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => EpisodeCharacterTile(
        character: characters[index],
        onTap: () => NavigationHelper.navigateToCharacterDetail(
          context,
          characters[index].id,
        ),
      ),
    );
  }
}
