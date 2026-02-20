import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/episode_model.dart';
import '../../../domain/repositories/episode_repository.dart';

part 'episodes_state.dart';

class EpisodesCubit extends Cubit<EpisodesState> {
  EpisodesCubit({required this.repository}) : super(const EpisodesState());

  final EpisodeRepository repository;

  Future<void> loadEpisodes(List<String> urls) async {
    if (urls.isEmpty) {
      emit(state.copyWith(status: EpisodesStatus.success, episodes: []));
      return;
    }

    emit(state.copyWith(status: EpisodesStatus.loading));

    final result = await repository.getEpisodesByUrls(urls);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EpisodesStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (episodes) => emit(
        state.copyWith(
          status: EpisodesStatus.success,
          episodes: episodes,
        ),
      ),
    );
  }
}
