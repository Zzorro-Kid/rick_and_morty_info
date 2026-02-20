import 'package:dartz/dartz.dart';
import '../../../../core/data/repository/base_repository.dart';
import '../../../../core/errors/failures.dart';
import '../entities/character_model.dart';
import '../entities/characters_response_model.dart';

abstract class CharacterRepository extends BaseRepository {
  CharacterRepository(super.networkInfo);

  Future<Either<Failure, CharactersResponseModel>> getCharacters({
    required int page,
    String name = '',
  });

  Future<Either<Failure, CharacterModel>> getCharacterDetail(int id);
}
