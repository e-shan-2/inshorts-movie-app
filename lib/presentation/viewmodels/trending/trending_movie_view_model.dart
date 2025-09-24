import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inshort_app/di/injector.dart';
import 'package:inshort_app/domain/repositories/movie_repository.dart';

import 'trending_movie_state.dart';

class MovieViewModel extends StateNotifier<MovieState> {
  final IMovieRepository repository;

  MovieViewModel(this.repository) : super(MovieState.initial());

  /// Initial fetch or refresh
  Future<void> fetchTrendingMovies(int pageNumber) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 1,
        hasMoreData: true,
      );

      final movies = await repository.getTrendingMovies(pageNumber);

      state = state.copyWith(
        trendingMoviesHomeScreen: movies,
        trendingMovies: movies,
        isLoading: false,
        currentPage: pageNumber,
        hasMoreData: movies.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Pagination
  Future<void> fetchMoreTrendingMovies() async {
    if (state.isLoadingMore || !state.hasMoreData) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final movies = await repository.getTrendingMovies(nextPage);

      state = state.copyWith(
        trendingMovies: [...state.trendingMovies, ...movies],
        currentPage: nextPage,
        isLoadingMore: false,
        hasMoreData: movies.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  /// Optional: Search with reset
  Future<void> searchMovies(String query) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 1,
        hasMoreData: false,
      );

      final movies = await repository.searchMovies(query);

      state = state.copyWith(
        trendingMovies: movies,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final movieViewModelProvider =
    StateNotifierProvider<MovieViewModel, MovieState>((ref) {
  final IMovieRepository repository = getIt<IMovieRepository>();
  return MovieViewModel(repository);
});
