import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inshort_app/presentation/viewmodels/connectivity_provider.dart';
import 'package:inshort_app/presentation/viewmodels/now_playing/now_playing_movie_provider.dart';
import 'package:inshort_app/presentation/viewmodels/trending/trending_movie_view_model.dart';
import 'package:inshort_app/presentation/widgets/no_content.dart';
import 'package:inshort_app/presentation/widgets/section_header.dart';
import 'package:inshort_app/presentation/widgets/movie_horizontal_list.dart';
import 'package:inshort_app/services/internet_connectivity_services.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAndFetch();
    });
  }

  Future<void> _checkAndFetch() async {
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection(context);
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(checkConnection);

    final trendingState = ref.read(movieViewModelProvider);
    if (trendingState.trendingMovies.isEmpty) {
      ref.read(movieViewModelProvider.notifier).fetchTrendingMovies(1);
    }

    final nowPlayingState = ref.read(nowPlayingmovieProvider);
    if (nowPlayingState.nowPlayingMoviesHomeScreen.isEmpty) {
      ref.read(nowPlayingmovieProvider.notifier).fetchNowPlayingMovies(1);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trendingState = ref.watch(movieViewModelProvider);
    final nowPlayingState = ref.watch(nowPlayingmovieProvider);
    // final isLoading = trendingState.isLoading || nowPlayingState.isLoading;

    final hasConnection = ref.watch(connectivityProvider) ;



    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
                  await _checkAndFetch();
            await ref
                .read(movieViewModelProvider.notifier)
                .fetchTrendingMovies(1);
            await ref
                .read(nowPlayingmovieProvider.notifier)
                .fetchNowPlayingMovies(1);
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text("Home",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white)),
              centerTitle: true,
            ),
            body: ((!hasConnection) &&
                    (trendingState.trendingMoviesHomeScreen.isEmpty ||
                    nowPlayingState.nowPlayingMoviesHomeScreen.isEmpty))
                ? NoContentWidget(
                    title: "Please Check Your Internet Connection")
                : Column(
                    children: [
                      const SizedBox(height: 8),
                   
                      Expanded(
                        child:
                            // isLoading
                            //     ? const HomeScreenSimmer()
                            //     :
                            SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Trending Movies Section
                              SectionHeader(
                                title: "Trending Movies",
                                onViewAll: () =>
                                    context.push('/allMovies', extra: true),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: MovieHorizontalList(
                                  movies:
                                      trendingState.trendingMoviesHomeScreen,
                                  isLoading: trendingState.isLoading,
                                  error: trendingState.error,
                                ),
                              ),

                              const SizedBox(height: 20),

                              /// Now Playing Movies Section
                              SectionHeader(
                                title: "Now Playing Movies",
                                onViewAll: () =>
                                    context.push('/allMovies', extra: false),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: MovieHorizontalList(
                                  movies: nowPlayingState
                                      .nowPlayingMoviesHomeScreen,
                                  isLoading: nowPlayingState.isLoading,
                                  error: nowPlayingState.error,
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
