import 'package:dio/dio.dart';
import 'package:inshort_app/core/constants/api_constants.dart';
import 'package:inshort_app/data/models/movie_detail_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../../models/movie_response.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/trending/movie/week')
  Future<MovieResponse> getTrendingMovies(
    @Query('page') int pageNumnber,
  );

  @GET('/movie/now_playing')
  Future<MovieResponse> getNowPlayingMovies(
    @Query('language') String language,
    @Query('page') int pageNumnber,
  );

  @GET('/movie')
  Future<MovieResponse> getAllMoview();
  @GET('/search/movie')
  Future<MovieResponse> searchMovies(@Query('query') String query);

  @GET('/movie/{id}')
  Future<MovieDetailModel> getMovieDetails(@Path('id') int  movieId);
}
