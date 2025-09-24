import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inshort_app/presentation/pages/all_list_movie.dart/all_list_movie.dart';
import 'package:inshort_app/presentation/viewmodels/connectivity_provider.dart';
import 'package:inshort_app/presentation/viewmodels/search/search_movie_provider.dart';
import 'package:inshort_app/presentation/viewmodels/trending/trending_movie_view_model.dart';
import 'package:inshort_app/presentation/widgets/movie_card_shimmer.dart';
import 'package:inshort_app/presentation/widgets/movie_image_card.dart';
import 'package:inshort_app/presentation/widgets/no_content.dart';
import 'package:inshort_app/presentation/widgets/shimmer.dart';
import 'package:inshort_app/presentation/widgets/shimmer_grid.dart';
import 'package:inshort_app/services/internet_connectivity_services.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _searchController;
  Timer? _debounce;
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
   await _checkAndFetch();
      final searchStateState = ref.read(searchMovieProviderProvider);
      if (searchStateState.searchMovieList.isEmpty) {
        ref.read(searchMovieProviderProvider.notifier).getAllMovies();
      }
    });

    _searchController = TextEditingController();

    _searchController.addListener(_onSearchChanged);
  }


   Future<void> _checkAndFetch() async {
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection(context);
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(checkConnection);

 
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
_checkAndFetch();
      if (query.isEmpty) {
        ref.read(searchMovieProviderProvider.notifier).getAllMovies();
      } else {
        ref.read(searchMovieProviderProvider.notifier).searchMovies(query);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchMovieProviderProvider);

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ),
              _buildBody(searchState)
            ],
          )),
    );
  }

  Widget _buildBody(searchState) {
    if (searchState.isLoading) {
      return ShimmerGrid();
    }

   else if (searchState.error != null && searchState.searchMovieList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error: ${searchState.error}',
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

   else if (searchState.searchMovieList.isEmpty ) {
      return Expanded(child: const NoContentWidget());
    }


    return Expanded(
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 cards per row
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.9,
        ),
        itemCount: searchState.searchMovieList.length  +
          (searchState.isLoading ? 3 : 0), 
        itemBuilder: (context, index) {
          if (index >= searchState.searchMovieList.length) {
            return const CustomShimmer(); // Shimmer loading for pagination
          }

          final movie = searchState.searchMovieList[index];
          return MovieImageCard(
             title: movie.title ??"N/A",
            imageUrl: movie.posterPath ?? "",
            onTap: () {
              context.push(
                '/movieDetails',
                extra: movie,
              );

              // Handle navigation or show detail
            },
          );
        },
      ),
    );
  }
}
