part of 'characters_cubit.dart';

enum CharactersStatus { initial, loading, loadingMore, success, failure }

class CharactersState extends Equatable {
  const CharactersState({
    this.status = CharactersStatus.initial,
    this.characters = const [],
    this.currentPage = 1,
    this.hasNextPage = true,
    this.query = '',
    this.errorMessage,
  });

  final CharactersStatus status;
  final List<CharacterModel> characters;
  final int currentPage;
  final bool hasNextPage;
  final String query;
  final String? errorMessage;

  CharactersState copyWith({
    CharactersStatus? status,
    List<CharacterModel>? characters,
    int? currentPage,
    bool? hasNextPage,
    String? query,
    String? errorMessage,
  }) {
    return CharactersState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    characters,
    currentPage,
    hasNextPage,
    query,
    errorMessage,
  ];
}
