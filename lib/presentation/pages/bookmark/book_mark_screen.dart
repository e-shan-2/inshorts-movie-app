import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inshort_app/presentation/viewmodels/book_marks/book_mark_provider.dart';
import 'package:inshort_app/presentation/widgets/movie_card.dart';
import 'package:inshort_app/presentation/widgets/movie_card_shimmer.dart';
import 'package:inshort_app/presentation/widgets/no_content.dart';

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(bookMarkProvider.notifier).getBookMarkList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookMarkProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(bookMarkProvider.notifier).getBookMarkList();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text("BookMarked Movies",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white)),
            centerTitle: true,
          ),
          body: state.isLoading
              ? ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return MovieCardShimmer();
                  })
              : (state.bookMarkMovieList.isEmpty && state.isLoading == false)
                  ? Center(child: NoContentWidget())
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      itemCount: state.bookMarkMovieList.length,
                      itemBuilder: (context, index) {
                        final movie = state.bookMarkMovieList[index];

                        return MovieCard(
                          title: movie.originalTitle ?? "",
                          overview: movie.overview ?? "",
                          posterPath: movie.posterPath ?? "",
                          adult: false,
                          bookMarkWidget: IconButton(
                            icon:
                            
                                
                                 Icon(Icons.bookmark_added_rounded,
                                    color: Colors.orange)
                          
                                    ,
                            onPressed: () async {
                              await ref
                                  .read(bookMarkProvider.notifier)
                                  .addBookmark(movie);
                              await ref
                                  .read(bookMarkProvider.notifier)
                                  .isBookMarkedOrNot(movie.id ?? 0);
                            },
                          ),
                          // onBookmarkToggle: () {
                          //   ref.read(bookMarkProvider.notifier).addBookmark(movie);
                          // },
                          onTap: () =>
                              context.push('/movieDetails', extra: movie),
                        );
                      }),
        ),
      ),
    );
  }
}
