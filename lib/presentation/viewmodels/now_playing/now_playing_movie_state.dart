import '../../../data/models/movie_model.dart';

class NowPlayingMovieState {
  final List<MovieModel> nowPlayingMovies;
  final List<MovieModel> nowPlayingMoviesHomeScreen;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMoreData;
  final int currentPage;
  final String? error;

  NowPlayingMovieState({
    required this.nowPlayingMovies,
    required this.nowPlayingMoviesHomeScreen,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMoreData,
    required this.currentPage,
    this.error,
  });

  factory NowPlayingMovieState.initial() => NowPlayingMovieState(
        nowPlayingMovies: [],
        nowPlayingMoviesHomeScreen: [],
        isLoading: false,
        isLoadingMore: false,
        hasMoreData: true,
        currentPage: 1,
        error: null,
      );

  NowPlayingMovieState copyWith({
    List<MovieModel>? nowPlayingMovies,
    List<MovieModel>? nowPlayingMoviesHomeScreen,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMoreData,
    int? currentPage,
    String? error,
  }) {
    return NowPlayingMovieState(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      nowPlayingMoviesHomeScreen:
          nowPlayingMoviesHomeScreen ?? this.nowPlayingMoviesHomeScreen,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }
}
