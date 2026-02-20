import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../injection_container.dart' as di;
import '../../../../core/utils/navigation_helper.dart';
import '../cubit/episodes/episodes_cubit.dart';

class EpisodesList extends StatelessWidget {
  const EpisodesList({super.key, required this.episodeUrls});

  final List<String> episodeUrls;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<EpisodesCubit>()..loadEpisodes(episodeUrls),
      child: BlocBuilder<EpisodesCubit, EpisodesState>(builder: _buildBody),
    );
  }

  Widget _buildBody(BuildContext context, EpisodesState state) {
    return switch (state.status) {
      EpisodesStatus.initial || EpisodesStatus.loading => _buildLoading(),
      EpisodesStatus.failure => _buildError(context, state),
      EpisodesStatus.success => _buildList(context, state),
    };
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(BuildContext context, EpisodesState state) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        state.errorMessage ?? 'Failed to load episodes',
        style: TextStyle(color: colorScheme.error),
      ),
    );
  }

  Widget _buildList(BuildContext context, EpisodesState state) {
    if (state.episodes.isEmpty) {
      return const Center(child: Text('No Episodes'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.episodes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) =>
          _buildEpisodeTile(context, state.episodes[index]),
    );
  }

  Widget _buildEpisodeTile(BuildContext context, dynamic episode) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            NavigationHelper.navigateToEpisodeDetail(context, episode.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              _buildEpisodeCode(episode.episode, colorScheme),
              const SizedBox(width: 12),
              Expanded(child: _buildEpisodeInfo(episode.name, colorScheme)),
              _buildChevron(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodeCode(String code, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildEpisodeInfo(String name, ColorScheme colorScheme) {
    return Text(
      name,
      style: const TextStyle(fontWeight: FontWeight.w500),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildChevron(ColorScheme colorScheme) {
    return Icon(
      Icons.chevron_right_rounded,
      color: colorScheme.onSurfaceVariant,
    );
  }
}
