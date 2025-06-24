import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app_clean_architecture/core/platform/networkinfo.dart';
import 'package:travel_app_clean_architecture/features/homepage/data/datasource/destination_local_data_source.dart';
import 'package:travel_app_clean_architecture/features/homepage/data/datasource/destination_remote_data_source.dart';
import 'package:travel_app_clean_architecture/features/homepage/data/repositories/destination_repositories_imp.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/repositories/destination_repository.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/usecase/get_all_destination_usecase.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/usecase/get_search_destination_usecase.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/usecase/get_top_destination_usecase.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/bloc/all_destination/all_destination_bloc.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/bloc/search_destination/search_destination_bloc.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/bloc/top_destination/top_destination_bloc.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

Future<void> initLocator() async {
  //bloc
  locator.registerFactory(() => AllDestinationBloc(locator()));
  locator.registerFactory(() => SearchDestinationBloc(locator()));
  locator.registerFactory(() => TopDestinationBloc(locator()));

  //usecases
  locator.registerLazySingleton(() => GetAllDestinationUsecase(locator()));
  locator.registerLazySingleton(() => GetSearchDestinationUsecase(locator()));
  locator.registerLazySingleton(() => GetTopDestinationUsecase(locator()));

  //repositories
  locator.registerLazySingleton<DestinationRepository>(
    () => DestinationRepositoriesImp(
      networkinfo: locator(),
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  //datasources
  locator.registerLazySingleton<DestinationLocalDataSource>(
    () => DestinationLocalDataSourceImpl(sharedPreferences: locator()),
  );

  locator.registerLazySingleton<DestinationRemoteDataSource>(
    () => DestinationRemoteDataSourceImpl(client: locator()),
  );

  //platform
  locator.registerLazySingleton<Networkinfo>(() => NetworkInfoImpl(locator()));

  //external
  final pref = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => Connectivity());
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => pref);
}
