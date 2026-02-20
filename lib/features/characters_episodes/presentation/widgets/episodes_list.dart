import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../injection_container.dart' as di;
import '../../../characters/presentation/utils/navigation_helper.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return switch (state.status) {
      EpisodesStatus.initial || EpisodesStatus.loading => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      EpisodesStatus.failure => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          state.errorMessage ?? 'Failed to load episodes',
          style: TextStyle(color: colorScheme.error),
        ),
      ),
      EpisodesStatus.success => _buildList(context, state, colorScheme),
    };
  }

  Widget _buildList(
    BuildContext context,
    EpisodesState state,
    ColorScheme colorScheme,
  ) {
    if (state.episodes.isEmpty) {
      return const Center(child: Text('No Episodes'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.episodes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final episode = state.episodes[index];
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      episode.episode,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      episode.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
