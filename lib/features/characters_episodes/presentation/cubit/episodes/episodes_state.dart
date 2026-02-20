part of 'episodes_cubit.dart';

enum EpisodesStatus { initial, loading, success, failure }

class EpisodesState extends Equatable {
  const EpisodesState({
    this.status = EpisodesStatus.initial,
    this.episodes = const [],
    this.errorMessage,
  });

  final EpisodesStatus status;
  final List<EpisodeModel> episodes;
  final String? errorMessage;

  EpisodesState copyWith({
    EpisodesStatus? status,
    List<EpisodeModel>? episodes,
    String? errorMessage,
  }) {
    return EpisodesState(
      status: status ?? this.status,
      episodes: episodes ?? this.episodes,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, episodes, errorMessage];
}
