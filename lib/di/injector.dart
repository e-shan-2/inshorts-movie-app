import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inshort_app/core/constants/api_constants.dart';
import 'package:inshort_app/core/network/dio_client.dart';
import 'package:inshort_app/core/utils/hive_contants.dart';
import 'package:inshort_app/data/datasources/remote/api_client.dart';
import 'package:inshort_app/data/models/movie_adaptor_model.dart';
import 'package:inshort_app/data/models/movie_model.dart';
import 'package:inshort_app/data/repositories/movie_repository_impl.dart';
import 'package:inshort_app/domain/repositories/movie_repository.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Initialize Hive and register adapter
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(MovieModelAdapter());

    await Hive.openBox<MovieModel>(HiveBoxes.trendingMovies);
    await Hive.openBox<MovieModel>(HiveBoxes.nowPlayingMovies);
    await Hive.openBox<MovieModel>(HiveBoxes.bookmarkedMovies);
  } catch (e) {
    // Log or handle Hive initialization/open errors
    print('Error initializing Hive or opening boxes: $e');
    // You can rethrow or handle accordingly
    rethrow;
  }

  // Retrieve boxes
  final trendingBox = Hive.box<MovieModel>(HiveBoxes.trendingMovies);
  final nowPlayingBox = Hive.box<MovieModel>(HiveBoxes.nowPlayingMovies);
  final bookmarkedBox = Hive.box<MovieModel>(HiveBoxes.bookmarkedMovies);

  // Register Dio client
  getIt.registerLazySingleton<Dio>(() => DioClient.createDio());

  // Register ApiClient
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(getIt<Dio>(), baseUrl: ApiConstants.baseUrl),
  );

  // Register Repository with both API client and Hive boxes
  getIt.registerLazySingleton<IMovieRepository>(() => MovieRepositoryImpl(
        apiClient: getIt<ApiClient>(),
        apiKey: ApiConstants.bearerToken,
        trendingBox: trendingBox,
        nowPlayingBox: nowPlayingBox,
        bookmarkedBox: bookmarkedBox,
      ));
}
