import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inshort_app/di/injector.dart';
import 'package:inshort_app/domain/repositories/movie_repository.dart';
import 'package:inshort_app/presentation/viewmodels/search/search_movie_state.dart';



class SearchMovieProvider extends StateNotifier<SearchMovieState> {
  final IMovieRepository repository;

  SearchMovieProvider(this.repository) : super(SearchMovieState.initial());



  Future<void> searchMovies(String query) async {
    // try {
      state = state.copyWith(isLoading: true, error: null ,);
      final movies = await repository.searchMovies(query);
      // debugger();
      state = state.copyWith(searchMovieList: movies, isLoading: false);
    // } catch (e) {
    //   state = state.copyWith(isLoading: false, error: e.toString());
    // }
  }
  Future<void> getAllMovies() async {
    // try {
      state = state.copyWith(isLoading: true, error: null);
  
    final movies = await repository.getAllovies();

      state = state.copyWith(searchMovieList: movies, isLoading: false);
    // } catch (e) {
    //   state = state.copyWith(isLoading: false, error: e.toString());
    // }
  }
}

final searchMovieProviderProvider =
    StateNotifierProvider<SearchMovieProvider, SearchMovieState>((ref) {
  final IMovieRepository repository = getIt<IMovieRepository>();

  return SearchMovieProvider(repository);
});
