import '../../../data/models/movie_model.dart';

class MovieState {
  final List<MovieModel> trendingMovies;
  final List<MovieModel> trendingMoviesHomeScreen;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMoreData;
  final int currentPage;
  final String? error;

  MovieState({
    required this.trendingMovies,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMoreData,
    required this.currentPage,
    required this.trendingMoviesHomeScreen,
    this.error,
  });

  factory MovieState.initial() => MovieState(
        trendingMovies: [],
        isLoading: false,
        isLoadingMore: false,
        hasMoreData: true, // assume true initially
        currentPage: 1,
        error: null,
        trendingMoviesHomeScreen: []
      );

  MovieState copyWith({
    List<MovieModel>? trendingMovies,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMoreData,
    int? currentPage,
    String? error,
   List<MovieModel>?   trendingMoviesHomeScreen,
  }) {
    return MovieState(
      trendingMovies: trendingMovies ?? this.trendingMovies,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPage: currentPage ?? this.currentPage,
      error: error,
      trendingMoviesHomeScreen: trendingMoviesHomeScreen ?? this.trendingMoviesHomeScreen
    );
  }
}
