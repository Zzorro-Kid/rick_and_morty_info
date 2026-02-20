import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../characters/domain/repository/character_repository.dart';
import 'characters_details_state.dart';

class CharacterDetailCubit extends Cubit<CharacterDetailState> {
  final CharacterRepository repository;

  CharacterDetailCubit(this.repository) : super(CharacterDetailInitial());

  Future<void> loadCharacterDetail(int id) async {
    emit(CharacterDetailLoading());

    final result = await repository.getCharacterDetail(id);

    result.fold(
      (error) => emit(CharacterDetailError(error.message)),
      (character) => emit(CharacterDetailLoaded(character)),
    );
  }
}
