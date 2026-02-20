import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../features/characters/domain/entities/character_model.dart';
import '../../../../../features/characters/domain/repository/character_repository.dart';
import '../../../domain/entities/episode_model.dart';
import '../../../domain/repositories/episode_repository.dart';

part 'episode_detail_state.dart';

class EpisodeDetailCubit extends Cubit<EpisodeDetailState> {
  EpisodeDetailCubit({
    required this.episodeRepository,
    required this.characterRepository,
  }) : super(const EpisodeDetailState());

  final EpisodeRepository episodeRepository;
  final CharacterRepository characterRepository;

  Future<void> loadEpisode(int id) async {
    emit(state.copyWith(status: EpisodeDetailStatus.loading));

    final result = await episodeRepository.getEpisode(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EpisodeDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (episode) async {
        emit(state.copyWith(
          status: EpisodeDetailStatus.success,
          episode: episode,
          charactersStatus: EpisodeDetailCharactersStatus.loading,
        ));
        await _loadCharacters(episode.characters);
      },
    );
  }

  Future<void> _loadCharacters(List<String> urls) async {
    if (urls.isEmpty) {
      emit(state.copyWith(
        charactersStatus: EpisodeDetailCharactersStatus.success,
        characters: [],
      ));
      return;
    }

    // извлекаем ID из URL вида https://rickandmortyapi.com/api/character/1
    final ids = urls
        .map((url) => int.tryParse(url.split('/').last))
        .whereType<int>()
        .toList();

    // грузим по одному через getCharacterDetail, параллельно
    final futures = ids.map((id) => characterRepository.getCharacterDetail(id));
    final results = await Future.wait(futures);

    final characters = <CharacterModel>[];
    String? error;

    for (final result in results) {
      result.fold(
        (failure) => error = failure.message,
        (character) => characters.add(character),
      );
    }

    if (error != null && characters.isEmpty) {
      emit(state.copyWith(
        charactersStatus: EpisodeDetailCharactersStatus.failure,
        errorMessage: error,
      ));
    } else {
      emit(state.copyWith(
        charactersStatus: EpisodeDetailCharactersStatus.success,
        characters: characters,
      ));
    }
  }
}
