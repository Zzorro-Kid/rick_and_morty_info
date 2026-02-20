import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info.dart';
import 'features/characters/data/repository/characters_repository_impl.dart';
import 'features/characters/data/sources/character_remote_data_source.dart';
import 'features/characters/domain/repository/character_repository.dart';
import 'features/characters/presentation/cubit/characters/characters_cubit.dart';
import 'features/characters_details/presentation/cubit/characters_details/characters_details_cubit.dart';
import 'features/characters_episodes/data/repositories/episode_repository_impl.dart';
import 'features/characters_episodes/data/sources/episode_remote_data_source.dart';
import 'features/characters_episodes/domain/repositories/episode_repository.dart';
import 'features/characters_episodes/presentation/cubit/episode_detail/episode_detail_cubit.dart';
import 'features/characters_episodes/presentation/cubit/episodes/episodes_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initExternal();
  _initCore();
  _initDataSources();
  _initRepositories();
  _initBloc();
}

Future<void> _initExternal() async {
  sl.registerLazySingleton(http.Client.new);
}

void _initCore() {
  sl.registerLazySingleton<NetworkInfo>(NetworkInfoImpl.new);
}

void _initDataSources() {
  sl.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<EpisodeRemoteDataSource>(
    () => EpisodeRemoteDataSourceImpl(client: sl()),
  );
}

void _initRepositories() {
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()),
  );
  sl.registerLazySingleton<EpisodeRepository>(
    () => EpisodeRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()),
  );
}

void _initBloc() {
  sl
    ..registerFactory(() => CharactersCubit(repository: sl()))
    ..registerFactory(() => CharacterDetailCubit(sl()))
    ..registerFactory(() => EpisodesCubit(repository: sl()))
    ..registerFactory(() => EpisodeDetailCubit(
          episodeRepository: sl(),
          characterRepository: sl(),
        ));
}
