import '../../../data/models/movie_model.dart';

class BookMarkMovieState {
  final List<MovieModel> bookMarkMovieList;
  final bool isLoading;
  final String? error;
  final bool ? isBookmarked ;
  BookMarkMovieState({
    required this.bookMarkMovieList,
    required this.isLoading,
    this.error,
    this.isBookmarked,
  });

  factory BookMarkMovieState.initial() => BookMarkMovieState(
        bookMarkMovieList: [],
        isLoading: true,
        error: null,
        isBookmarked:null
      );

  BookMarkMovieState copyWith({
    List<MovieModel>? bookMarkMovieList,
    bool? isLoading,
    String? error,
    bool ?isBookmarked
  }) {
    return BookMarkMovieState(
      bookMarkMovieList: bookMarkMovieList ?? this.bookMarkMovieList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isBookmarked: isBookmarked
    );
  }
}
