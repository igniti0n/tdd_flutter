import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get_it/get_it.dart' as getit;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd/core/network/network_info.dart';
import 'package:tdd/core/util/input_converter.dart';
import 'package:tdd/features/number_trivia/data/datasources/local_data_source.dart';
import 'package:tdd/features/number_trivia/data/datasources/network_data_source.dart';
import 'package:tdd/features/number_trivia/data/repositories/number_trivia_repositroy_impl.dart';
import 'package:tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final sl = getit.GetIt.instance;

Future<void> initDependencies() async {
  //!features
  sl.registerFactory(
    () => NumberTriviaBloc(
        getConcreteNumberTrivia: sl(),
        getRandomNumberTrivia: sl(),
        inputParser: sl()),
  );

  //datasources
  sl.registerLazySingleton<NetworkDataSource>(
      () => NetworkDataSourceImpl(sl()));
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sl()));

  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImplementation(
            localDataSource: sl(),
            networkDataSource: sl(),
            networkInfo: sl(),
          ));

  //usecases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(repository: sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(repository: sl()));

  //!core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());

  //!external
  final sp = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sp);
  sl.registerLazySingleton<http.Client>(() => http.Client());
}
