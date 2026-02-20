import 'package:dartz/dartz.dart';
import '../../../../core/data/repository/base_repository.dart';
import '../../../../core/errors/failures.dart';
import '../entities/episode_model.dart';

abstract class EpisodeRepository extends BaseRepository {
  EpisodeRepository(super.networkInfo);

  Future<Either<Failure, EpisodeModel>> getEpisode(int id);
  Future<Either<Failure, List<EpisodeModel>>> getEpisodesByUrls(List<String> urls);
}
