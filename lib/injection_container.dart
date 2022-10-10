import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeServiceLocator() async {
  // Bloc

  serviceLocator.registerFactory(
    () => NumberTriviaBloc(
      concreteNumber: serviceLocator(),
      randomNumber: serviceLocator(),
      inputConverter: serviceLocator(),
    ),
  );

  // Get concrete & random number

  serviceLocator.registerLazySingleton(
    () => GetConcreteNumberTrivia(
      numberTriviaRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetRandomNumberTrivia(
      numberTriviaRepository: serviceLocator(),
    ),
  );

  // Repository

  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      numberTriviaRemoteDataSource: serviceLocator(),
      numberTriviaLocalDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // Remore, local dan network info

  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      dataConnectionChecker: serviceLocator(),
    ),
  );

  // Input Converter

  serviceLocator.registerLazySingleton(() => InputConverter());

  // External

  final sharedPreferences = await SharedPreferences.getInstance();

  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}
