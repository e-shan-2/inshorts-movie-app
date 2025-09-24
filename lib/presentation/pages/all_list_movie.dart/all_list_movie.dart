import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inshort_app/presentation/viewmodels/connectivity_provider.dart';
import 'package:inshort_app/presentation/viewmodels/now_playing/now_playing_movie_provider.dart';
import 'package:inshort_app/presentation/widgets/movie_card.dart';
import 'package:inshort_app/presentation/widgets/movie_card_shimmer.dart';
import 'package:inshort_app/presentation/widgets/movie_image_card.dart';
import 'package:inshort_app/presentation/widgets/no_content.dart';
import 'package:inshort_app/presentation/viewmodels/trending/trending_movie_view_model.dart';
import 'package:inshort_app/presentation/widgets/shimmer.dart';
import 'package:inshort_app/presentation/widgets/shimmer_grid.dart';
import 'package:inshort_app/services/internet_connectivity_services.dart';

class MovieGridScreen extends ConsumerStatefulWidget {
  final bool fetchTrending; // true = trending, false = now playing

  const MovieGridScreen({super.key, required this.fetchTrending});

  @override
  ConsumerState<MovieGridScreen> createState() => _MovieGridScreenState();
}

class _MovieGridScreenState extends ConsumerState<MovieGridScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndFetch();
      if (widget.fetchTrending) {
        ref.read(movieViewModelProvider.notifier).fetchTrendingMovies(1);
      } else {
        ref.read(nowPlayingmovieProvider.notifier).fetchNowPlayingMovies(1);
      }
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isFetchingMore) {
      _isFetchingMore = true;

      if (widget.fetchTrending) {
        final state = ref.read(movieViewModelProvider);
        if (!state.isLoadingMore && !state.isLoading && state.hasMoreData) {
             bool checkConnection =
              await CheckInternetConnection().checkInternetConnection(context);
          ref
              .read(connectivityProvider.notifier)
              .updateConnectionStatus(checkConnection);

              
          if (checkConnection) {

          ref
              .read(movieViewModelProvider.notifier)
              .fetchMoreTrendingMovies()
              .then((_) => _isFetchingMore = false);
          }
        } else {
          _isFetchingMore = false;
        }
      } else {
        final state = ref.read(nowPlayingmovieProvider);
        if (!state.isLoadingMore && !state.isLoading && state.hasMoreData) {
          bool checkConnection =
              await CheckInternetConnection().checkInternetConnection(context);
          ref
              .read(connectivityProvider.notifier)
              .updateConnectionStatus(checkConnection);

          if (checkConnection) {
            ref
                .read(nowPlayingmovieProvider.notifier)
                .fetchMoreNowPlayingMovies()
                .then((_) => _isFetchingMore = false);
          }
        } else {
          _isFetchingMore = false;
        }
      }
    }
  }

  Future<void> _checkAndFetch() async {
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection(context);
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(checkConnection);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTrending = widget.fetchTrending;

    // Separate state reads
    final trendingState = ref.watch(movieViewModelProvider);
    final nowPlayingState = ref.watch(nowPlayingmovieProvider);

    final movies = isTrending
        ? trendingState.trendingMovies
        : nowPlayingState.nowPlayingMovies;

    final isLoading =
        isTrending ? trendingState.isLoading : nowPlayingState.isLoading;

    final error = isTrending ? trendingState.error : nowPlayingState.error;

    final isLoadingMore = isTrending
        ? trendingState.isLoadingMore
        : nowPlayingState.isLoadingMore;

    if (isLoading && movies.isEmpty) {
      return const ShimmerGrid();
    }

    if (error != null && movies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (movies.isEmpty) {
      return const NoContentWidget();
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (isTrending) {
          await ref
              .read(movieViewModelProvider.notifier)
              .fetchTrendingMovies(1);
        } else {
          await ref
              .read(nowPlayingmovieProvider.notifier)
              .fetchNowPlayingMovies(1);
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text("${isTrending ? "Trending " : "Now Playing "}Movies",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white)),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
          body: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemCount: movies.length + (isLoadingMore ? 3 : 0),
            itemBuilder: (context, index) {
              if (index >= movies.length) {
                return const CustomShimmer();
              }

              final movie = movies[index];
              return MovieImageCard(
                title: movie.title ?? "N/A",
                imageUrl: movie.posterPath ?? "",
                onTap: () {
                  context.push('/movieDetails', extra: movie);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
