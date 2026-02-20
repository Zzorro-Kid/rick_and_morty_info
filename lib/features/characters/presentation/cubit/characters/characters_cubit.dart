import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/character_model.dart';
import '../../../domain/repository/character_repository.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit({required this.repository}) : super(const CharactersState());

  final CharacterRepository repository;

  Future<void> fetchCharacters({String query = ''}) async {
    emit(
      state.copyWith(
        status: CharactersStatus.loading,
        characters: [],
        currentPage: 1,
        hasNextPage: true,
        query: query,
        errorMessage: null,
      ),
    );

    final result = await repository.getCharacters(page: 1, name: query);

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: CharactersStatus.failure,
          errorMessage: failure.message,
        ),
      ),
          (data) => emit(
        state.copyWith(
          status: CharactersStatus.success,
          characters: data.results,
          hasNextPage: data.info.next != null,
        ),
      ),
    );
  }

  Future<void> fetchNextPage() async {
    if (!state.hasNextPage) return;
    if (state.status == CharactersStatus.loadingMore) return;

    final nextPage = state.currentPage + 1;

    emit(state.copyWith(status: CharactersStatus.loadingMore));

    final result = await repository.getCharacters(
      page: nextPage,
      name: state.query,
    );

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: CharactersStatus.success,
          errorMessage: failure.message,
        ),
      ),
          (data) => emit(
        state.copyWith(
          status: CharactersStatus.success,
          characters: [...state.characters, ...data.results],
          currentPage: nextPage,
          hasNextPage: data.info.next != null,
          errorMessage: null,
        ),
      ),
    );
  }
}