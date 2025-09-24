import 'package:hive/hive.dart';
import 'package:inshort_app/data/models/movie_model.dart';


class MovieLocalRepository {
  final Box<MovieModel> _trendingBox;
  final Box<MovieModel> _nowPlayingBox;
  final Box<MovieModel> _bookmarkBox;

  MovieLocalRepository({
    required Box<MovieModel> trendingBox,
    required Box<MovieModel> nowPlayingBox,
    required Box<MovieModel> bookmarkBox,
  })  : _trendingBox = trendingBox,
        _nowPlayingBox = nowPlayingBox,
        _bookmarkBox = bookmarkBox;

  // --- Trending Movies ---
  List<MovieModel> getTrendingMovies() => _trendingBox.values.toList();

  Future<void> cacheTrendingMovies(List<MovieModel> movies) async {
    await _cacheMovies(_trendingBox, movies);
  }

  // --- Now Playing Movies ---
  List<MovieModel> getNowPlayingMovies() => _nowPlayingBox.values.toList();

  Future<void> cacheNowPlayingMovies(List<MovieModel> movies) async {
    await _cacheMovies(_nowPlayingBox, movies);
  }

  // --- Bookmarks ---
  List<MovieModel> getBookmarkedMovies() => _bookmarkBox.values.toList();

  Future<void> addBookmark(MovieModel movie) async {
    if (movie.id != null) {
      await _bookmarkBox.put(movie.id, movie);
    }
  }

  Future<void> removeBookmark(int movieId) async {
    await _bookmarkBox.delete(movieId);
  }

  bool isBookmarked(int movieId) {
    return _bookmarkBox.containsKey(movieId);
  }

  Future<void> toggleBookmark(MovieModel movie) async {
    if (movie.id == null) return;
    if (isBookmarked(movie.id!)) {
      await removeBookmark(movie.id!);
    } else {
      await addBookmark(movie);
    }
  }

  // --- Private helper for caching ---
  Future<void> _cacheMovies(Box<MovieModel> box, List<MovieModel> movies) async {
    await box.clear();
    for (var movie in movies) {
      if (movie.id != null) {
        await box.put(movie.id, movie);
      }
    }
  }
}
