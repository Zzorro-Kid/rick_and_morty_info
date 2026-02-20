import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_test_task/features/characters/domain/entities/character_model.dart';
import 'package:rick_and_morty_test_task/features/characters/domain/entities/info_model.dart';

class CharactersResponseModel extends Equatable {
  final InfoModel info;
  final List<CharacterModel> results;

  const CharactersResponseModel({required this.info, required this.results});

  @override
  List<Object?> get props => [info, results];
}
