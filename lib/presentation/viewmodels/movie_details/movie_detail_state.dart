import 'package:inshort_app/data/models/movie_detail_model.dart';

import '../../../data/models/movie_model.dart';

class MovieDetailsState {
  final MovieDetailModel? movieDetailsData;
  final bool isLoading;
  final String? error;

  MovieDetailsState({
     this.movieDetailsData,
    required this.isLoading,
    this.error,
  });

  factory MovieDetailsState.initial() => MovieDetailsState(
        movieDetailsData: null,
        isLoading: true,
        error: null,
      );

  MovieDetailsState copyWith({
   MovieDetailModel ? movieDetailsData,
    bool? isLoading,
    String? error,
  }) {
    return MovieDetailsState(
      movieDetailsData: movieDetailsData ?? this.movieDetailsData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
