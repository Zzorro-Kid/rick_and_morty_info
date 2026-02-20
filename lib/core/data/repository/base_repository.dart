import 'package:dartz/dartz.dart';
import '../../errors/exceptions.dart';
import '../../errors/failures.dart';
import '../../network/network_info.dart';

class BaseRepository {
  final NetworkInfo networkInfo;

  BaseRepository(this.networkInfo);

  Future<Either<Failure, T>> checkNetworkAndDoRequest<T>({
    required Future<T> Function() remoteRequest,
  }) async {
    if (await networkInfo.isConnected) {
      return _executeRemoteRequest(remoteRequest);
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  Future<Either<Failure, T>> _executeRemoteRequest<T>(
    Future<T> Function() remoteRequest,
  ) async {
    try {
      final result = await remoteRequest();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on UnexpectedException catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.errorCode}'));
    }
  }
}
