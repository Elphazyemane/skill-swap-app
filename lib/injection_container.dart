import 'package:get_it/get_it.dart';
import 'core/network/dio_client.dart';
import 'data/datasources/skill_remote_datasource.dart';
import 'data/repositories/skill_repository.dart';
import 'presentation/blocs/skill_bloc.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  // Network
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Data sources
  sl.registerLazySingleton<SkillRemoteDataSource>(
    () => SkillRemoteDataSourceImpl(dioClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<SkillRepository>(
    () => SkillRepositoryImpl(remoteDataSource: sl()),
  );

  // Bloc
  sl.registerFactory<SkillBloc>(
    () => SkillBloc(skillRepository: sl()),
  );
}