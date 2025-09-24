import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inshort_app/di/injector.dart';
import 'package:inshort_app/domain/repositories/movie_repository.dart';
import 'now_playing_movie_state.dart';

class NowPlayingProvider extends StateNotifier<NowPlayingMovieState> {
  final IMovieRepository repository;

  NowPlayingProvider(this.repository) : super(NowPlayingMovieState.initial());

  /// Initial fetch or refresh
  Future<void> fetchNowPlayingMovies(int pageNumber) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 1,
        hasMoreData: true,
      );

      final movies = await repository.getNowPlayingMovies(pageNumber);
      log("✅ Now Playing Movies Fetched: ${movies.length}");

      state = state.copyWith(
        nowPlayingMovies: movies,
        nowPlayingMoviesHomeScreen: movies,
        isLoading: false,
        currentPage: pageNumber,
        hasMoreData: movies.isNotEmpty,
      );
    } catch (e) {
      debugger();
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Pagination
  Future<void> fetchMoreNowPlayingMovies() async {
    if (state.isLoadingMore || !state.hasMoreData) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final movies = await repository.getNowPlayingMovies(nextPage);
      log("📦 Fetched page $nextPage with ${movies.length} movies");

      state = state.copyWith(
        nowPlayingMovies: [...state.nowPlayingMovies, ...movies],
        currentPage: nextPage,
        isLoadingMore: false,
        hasMoreData: movies.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  /// Optional: Search
  Future<void> searchMovies(String query) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 1,
        hasMoreData: false, // No pagination assumed in search
      );

      final movies = await repository.searchMovies(query);

      state = state.copyWith(
        nowPlayingMovies: movies,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final nowPlayingmovieProvider =
    StateNotifierProvider<NowPlayingProvider, NowPlayingMovieState>((ref) {
  final IMovieRepository repository = getIt<IMovieRepository>();
  return NowPlayingProvider(repository);
});
