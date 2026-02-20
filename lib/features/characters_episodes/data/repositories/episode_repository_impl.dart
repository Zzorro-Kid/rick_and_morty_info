import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/episode_model.dart';
import '../../domain/repositories/episode_repository.dart';
import '../sources/episode_remote_data_source.dart';

class EpisodeRepositoryImpl extends EpisodeRepository {
  EpisodeRepositoryImpl({
    required NetworkInfo networkInfo,
    required this.remoteDataSource,
  }) : super(networkInfo);

  final EpisodeRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, EpisodeModel>> getEpisode(int id) {
    return checkNetworkAndDoRequest(
      remoteRequest: () => remoteDataSource.getEpisode(id),
    );
  }

  @override
  Future<Either<Failure, List<EpisodeModel>>> getEpisodesByUrls(
    List<String> urls,
  ) {
    return checkNetworkAndDoRequest(
      remoteRequest: () => remoteDataSource.getEpisodesByUrls(urls),
    );
  }
}
