import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/character_model.dart';
import '../../domain/entities/characters_response_model.dart';
import '../../domain/repository/character_repository.dart';
import '../sources/character_remote_data_source.dart';

class CharacterRepositoryImpl extends CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;

  CharacterRepositoryImpl({
    required NetworkInfo networkInfo,
    required this.remoteDataSource,
  }) : super(networkInfo);

  @override
  Future<Either<Failure, CharactersResponseModel>> getCharacters({
    required int page,
    String name = '',
  }) async {
    return checkNetworkAndDoRequest<CharactersResponseModel>(
      remoteRequest: () => name.isEmpty
          ? remoteDataSource.getCharacters(page)
          : remoteDataSource.searchCharacters(name, page),
    );
  }

  @override
  Future<Either<Failure, CharacterModel>> getCharacterDetail(int id) async {
    return checkNetworkAndDoRequest<CharacterModel>(
      remoteRequest: () => remoteDataSource.getCharacterDetail(id),
    );
  }
}
