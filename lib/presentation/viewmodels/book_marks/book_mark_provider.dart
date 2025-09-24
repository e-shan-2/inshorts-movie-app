import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:inshort_app/core/utils/hive_contants.dart';
import 'package:inshort_app/data/models/movie_model.dart';
import 'package:inshort_app/di/injector.dart';
import 'package:inshort_app/domain/repositories/movie_repository.dart';
import 'package:inshort_app/presentation/viewmodels/book_marks/book_mark_state.dart';
import 'package:inshort_app/presentation/viewmodels/search/search_movie_state.dart';

class BookMaarkProvider extends StateNotifier<BookMarkMovieState> {
  final IMovieRepository repository;

  BookMaarkProvider(this.repository) : super(BookMarkMovieState.initial());
   final bookMark = Hive.box<MovieModel>(HiveBoxes.bookmarkedMovies);
  Future<void> getBookMarkList() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );
    final movies = await repository.getBookmarkedMovies();

    state = state.copyWith(bookMarkMovieList: movies, isLoading: false);
  }

  Future<void> addBookmark(MovieModel movie) async {
    await repository.addBookmark(movie);
     final movies = await repository.getBookmarkedMovies();

    state = state.copyWith(bookMarkMovieList: movies, isLoading: false);
  }
  Future<void> isBookMarkedOrNot(int movieId) async {
   final value= await bookMark.containsKey(movieId);

   state=state.copyWith(isBookmarked: value);
  }
}

final bookMarkProvider =
    StateNotifierProvider<BookMaarkProvider, BookMarkMovieState>((ref) {
  final IMovieRepository repository = getIt<IMovieRepository>();

  return BookMaarkProvider(repository);
});
