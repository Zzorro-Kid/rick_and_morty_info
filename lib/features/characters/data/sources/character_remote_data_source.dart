import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/data/sources/base_remote_data_source.dart';
import '../models/character_data_model.dart';
import '../models/characters_response_data_model.dart';

abstract class CharacterRemoteDataSource {
  Future<CharactersResponseDataModel> getCharacters(int page);
  Future<CharactersResponseDataModel> searchCharacters(String name, int page);
  Future<CharacterDataModel> getCharacterDetail(int id);
}

class CharacterRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CharacterRemoteDataSource {
  const CharacterRemoteDataSourceImpl({required super.client});

  @override
  Future<CharactersResponseDataModel> getCharacters(int page) async {
    final response = await get(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.charactersEndpoint}?page=$page',
      ),
    );

    final json = handleObjectResponse(response);
    return CharactersResponseDataModel.fromJson(json);
  }

  @override
  Future<CharactersResponseDataModel> searchCharacters(
    String name,
    int page,
  ) async {
    final response = await get(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.charactersEndpoint}?name=$name&page=$page',
      ),
    );

    final json = handleObjectResponse(response);
    return CharactersResponseDataModel.fromJson(json);
  }

  @override
  Future<CharacterDataModel> getCharacterDetail(int id) async {
    final response = await get(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.charactersEndpoint}/$id',
      ),
    );

    final json = handleObjectResponse(response);
    return CharacterDataModel.fromJson(json);
  }
}
