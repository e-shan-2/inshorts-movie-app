import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:inshort_app/data/models/movie_detail_model.dart';

import '../../domain/repositories/movie_repository.dart';
import '../datasources/remote/api_client.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements IMovieRepository {
  final ApiClient apiClient;
  final String apiKey;

  // Hive boxes for caching
  final Box<MovieModel> trendingBox;
  final Box<MovieModel> nowPlayingBox;
  final Box<MovieModel> bookmarkedBox;

  MovieRepositoryImpl({
    required this.apiClient,
    required this.apiKey,
    required this.trendingBox,
    required this.nowPlayingBox,
    required this.bookmarkedBox,
  });

  @override
  Future<List<MovieModel>> getTrendingMovies(int pageNumber) async {
    try {
      final response = await apiClient.getTrendingMovies(pageNumber);
      final movies = response.movies ?? [];
      log("$movies -----value");
      // Cache to Hive

      if (pageNumber == 1) {
        await _cacheMovies(trendingBox, movies);
      }

      return movies;
    } catch (e) {
      log('Failed to fetch trending movies from API, loading from cache: $e');
      // Return cached data if API fails

      return trendingBox.values.toList();
    }
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies(int pageNumber) async {
    try {
      final response = await apiClient.getNowPlayingMovies("en-US", pageNumber);
      final movies = response.movies ?? [];

      // Cache to Hive
      await _cacheMovies(nowPlayingBox, movies);

      return movies;
    } catch (e) {
      log('Failed to fetch now playing movies from API, loading from cache: $e');
      // Return cached data if API fails
      return nowPlayingBox.values.toList();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await apiClient.searchMovies(query);
      return response.movies ?? [];
    } catch (e) {
      log('Failed to search movies: $e');
      return [];
    }
  }

  // Bookmarks

  @override
  Future<void> addBookmark(MovieModel movie) async {
    if (bookmarkedBox.containsKey(movie.id)) {
      await bookmarkedBox.delete(movie.id);
    } else {
      await bookmarkedBox.put(movie.id, movie);
    }
  }

  @override
  Future<void> removeBookmark(int movieId) async {
    await bookmarkedBox.delete(movieId);
  }

  @override
  Future<List<MovieModel>> getBookmarkedMovies() async {
    return bookmarkedBox.values.toList();
  }

  // Helper to cache list of movies in box, clears old cache
  Future<void> _cacheMovies(
      Box<MovieModel> box, List<MovieModel> movies) async {
    await box.clear();
    for (var movie in movies) {
      if (movie.id != null) {
        await box.put(movie.id, movie);
      }
    }
  }

  @override
  Future<List<MovieModel>> getAllovies() async {
    try {
      final response = await apiClient.getTrendingMovies(1);
      final movies = response.movies ?? [];

      // Cache to Hive

      return movies;
    } catch (e) {
      // Return cached data if API fails
      return trendingBox.values.toList();
    }
  }

  @override
  Future<MovieDetailModel> getMovieDetails(int id) async {
    try {
      final response = await apiClient.getMovieDetails(id);
      return response;
    } catch (e) {
      return MovieDetailModel();
    }
  }
}
