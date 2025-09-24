import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inshort_app/di/injector.dart';
import 'package:inshort_app/domain/repositories/movie_repository.dart';
import 'package:inshort_app/presentation/viewmodels/movie_details/movie_detail_state.dart';
import 'package:inshort_app/presentation/viewmodels/search/search_movie_state.dart';



class MovieDetailProvider extends StateNotifier<MovieDetailsState> {
  final IMovieRepository repository;

  MovieDetailProvider(this.repository) : super(MovieDetailsState.initial());



  Future<void> getMovieDetails(int  id) async {
    try {
      state = state.copyWith(isLoading: true, error: null ,);
      final movies = await repository.getMovieDetails(id);

      state = state.copyWith(movieDetailsData: movies, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

}

final movieDetailProviderProvider =
    StateNotifierProvider<MovieDetailProvider, MovieDetailsState>((ref) {
  final IMovieRepository repository = getIt<IMovieRepository>();

  return MovieDetailProvider(repository);
});
