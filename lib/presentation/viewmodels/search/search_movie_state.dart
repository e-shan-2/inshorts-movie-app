import '../../../data/models/movie_model.dart';

class SearchMovieState {
  final List<MovieModel> searchMovieList;
  final bool isLoading;
  final String? error;

  SearchMovieState({
    required this.searchMovieList,
    required this.isLoading,
    this.error,
  });

  factory SearchMovieState.initial() => SearchMovieState(
        searchMovieList: [],
        isLoading: true,
        error: null,
      );

  SearchMovieState copyWith({
    List<MovieModel>? searchMovieList,
    bool? isLoading,
    String? error,
  }) {
    return SearchMovieState(
      searchMovieList: searchMovieList ?? this.searchMovieList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
