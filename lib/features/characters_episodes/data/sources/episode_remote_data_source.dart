import '../../../../core/data/sources/base_remote_data_source.dart';
import '../models/episode_data_model.dart';

abstract class EpisodeRemoteDataSource {
  Future<EpisodeDataModel> getEpisode(int id);
  Future<List<EpisodeDataModel>> getEpisodesByUrls(List<String> urls);
}

class EpisodeRemoteDataSourceImpl extends BaseRemoteDataSource
    implements EpisodeRemoteDataSource {
  const EpisodeRemoteDataSourceImpl({required super.client});

  @override
  Future<EpisodeDataModel> getEpisode(int id) async {
    final response = await get(Uri.parse('https://rickandmortyapi.com/api/episode/$id'));
    final json = handleObjectResponse(response);
    return EpisodeDataModel.fromJson(json);
  }

  @override
  Future<List<EpisodeDataModel>> getEpisodesByUrls(List<String> urls) async {
    final futures = urls.map((url) async {
      final response = await get(Uri.parse(url));
      final json = handleObjectResponse(response);
      return EpisodeDataModel.fromJson(json);
    });

    final results = await Future.wait(futures);
    return results;
  }
}
