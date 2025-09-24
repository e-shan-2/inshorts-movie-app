import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inshort_app/data/models/movie_model.dart';
import 'package:inshort_app/presentation/pages/all_list_movie.dart/all_list_movie.dart';
import 'package:inshort_app/presentation/pages/bookmark/book_mark_screen.dart';
import 'package:inshort_app/presentation/pages/bottom_nav/bottom_nav.dart';
import 'package:inshort_app/presentation/pages/home/home_screen.dart';
import 'package:inshort_app/presentation/pages/movie_details/movie%20_details%20_screen.dart';
import 'package:inshort_app/presentation/pages/movie_details/movie_details_screen_data.dart';
import 'package:inshort_app/presentation/pages/splash/splash%20screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/baseScreen',
      builder: (context, state) => const BottomNavController(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/allMovies',
      builder: (context, state) {
        final type = state.extra as bool;
        return MovieGridScreen(
          fetchTrending: type,
        );
      },
    ),
    GoRoute(
      path: '/movieDetails',
      name: 'movieDetails',
      builder: (context, state) {
        final movie = state.extra as MovieModel;
        return MovieDetailPage(movie: movie);
      },
    ),
    GoRoute(
      path: '/movieDetailsScreen/:id',
      name: 'movieDetailsScreen',
      builder: (context, state) {
        final movieId = state.pathParameters['id']!;
   
        return MovieDetailScreen(movieId: int.parse(movieId));
      },
    ),
    // GoRoute(
    //   path: '/search',
    //   builder: (context, state) => const SearchPage(),
    // ),
    // GoRoute(
    //   path: '/bookmarks',
    //   builder: (context, state) => const BookmarksPage(),
    // ),
    // GoRoute(
    //   path: '/movies',
    //   builder: (context, state) => const MovieListPage(),
    // ),
    // GoRoute(
    //   path: '/movie/:id',
    //   builder: (context, state) {
    //     final id = state.pathParameters['id']!;
    //     return MovieDetailPage(id: id);
    //   },
    // ),
  ],
);
