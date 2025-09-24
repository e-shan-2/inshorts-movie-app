import 'package:inshort_app/data/models/movie_detail_model.dart';

import '../../data/models/movie_model.dart';

abstract class IMovieRepository {
  Future<List<MovieModel>> getTrendingMovies(int pageNumbe);
  Future<List<MovieModel>> getNowPlayingMovies(int pageNumber);
  Future<List<MovieModel>> searchMovies(String query);
  Future<List<MovieModel>> getAllovies();
  
  Future<void> addBookmark(MovieModel movie);
  Future<void> removeBookmark(int movieId) ;
  Future<List<MovieModel>> getBookmarkedMovies();
  Future<MovieDetailModel> getMovieDetails(int id );

}
