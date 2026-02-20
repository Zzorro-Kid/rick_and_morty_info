part of 'episode_detail_cubit.dart';

enum EpisodeDetailStatus { initial, loading, success, failure }
enum EpisodeDetailCharactersStatus { initial, loading, success, failure }

class EpisodeDetailState extends Equatable {
  const EpisodeDetailState({
    this.status = EpisodeDetailStatus.initial,
    this.charactersStatus = EpisodeDetailCharactersStatus.initial,
    this.episode,
    this.characters = const [],
    this.errorMessage,
  });

  final EpisodeDetailStatus status;
  final EpisodeDetailCharactersStatus charactersStatus;
  final EpisodeModel? episode;
  final List<CharacterModel> characters;
  final String? errorMessage;

  EpisodeDetailState copyWith({
    EpisodeDetailStatus? status,
    EpisodeDetailCharactersStatus? charactersStatus,
    EpisodeModel? episode,
    List<CharacterModel>? characters,
    String? errorMessage,
  }) {
    return EpisodeDetailState(
      status: status ?? this.status,
      charactersStatus: charactersStatus ?? this.charactersStatus,
      episode: episode ?? this.episode,
      characters: characters ?? this.characters,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, charactersStatus, episode, characters, errorMessage];
}
