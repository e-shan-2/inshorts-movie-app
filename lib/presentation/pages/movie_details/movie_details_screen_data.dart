import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inshort_app/core/constants/api_constants.dart';
import 'package:inshort_app/data/models/movie_detail_model.dart';
import 'package:inshort_app/data/models/movie_model.dart';
import 'package:inshort_app/presentation/viewmodels/book_marks/book_mark_provider.dart';
import 'package:inshort_app/presentation/viewmodels/connectivity_provider.dart';
import 'package:inshort_app/presentation/viewmodels/movie_details/movie_detail_provider.dart';
import 'package:inshort_app/presentation/widgets/no_content.dart';
import 'package:inshort_app/services/internet_connectivity_services.dart';
import 'package:inshort_app/services/url_shortner.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:share_plus/share_plus.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  final int movieId;
  const MovieDetailScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen> {
  static const _iconColors = [
    Colors.tealAccent,
    Colors.pinkAccent,
    Colors.amberAccent,
    Colors.lightBlueAccent,
    Colors.deepPurpleAccent,
  ];

  String _imageUrl(String? path) =>
      (path?.isNotEmpty ?? false) ? 'https://image.tmdb.org/t/p/w500$path' : '';

  String _languageName(String? code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ja':
        return 'Japanese';
      case 'fr':
        return 'French';
      case 'es':
        return 'Spanish';
      case 'ko':
        return 'Korean';
      default:
        return code?.toUpperCase() ?? 'N/A';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkAndFetch();
    });
  }

  Future<void> _checkAndFetch() async {
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection(context);
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(checkConnection);

    if (checkConnection) {
      await ref
          .read(movieDetailProviderProvider.notifier)
          .getMovieDetails(widget.movieId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookMarkProvider);
    final movieDetailState = ref.watch(movieDetailProviderProvider);
    final movieDataModel =
        movieDetailState.movieDetailsData ?? MovieDetailModel();
    final hasConnection = ref.watch(connectivityProvider);
    final size = MediaQuery.of(context).size;
    final posterWidth = 120.0;
    final posterHeight = posterWidth * 1.5;

    final titleStyle = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    final contentStyle = const TextStyle(
      fontSize: 16,
      color: Colors.white70,
      height: 1.4,
    );

    return RefreshIndicator(
      onRefresh: () => _checkAndFetch(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: (!hasConnection)
            ? Expanded(child: NoContentWidget(title: "Please Check Your Internet Connection"))
            : movieDetailState.isLoading
                ? Center(child: CircularProgressIndicator())
                : (movieDetailState.error != null)
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Error: ${movieDetailState.error}',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildBackdrop(
                                    size.height * 0.45,
                                    movieDataModel.title ?? "N/A",
                                    movieDataModel),
                                _buildMovieInfo(
                                  posterHeight,
                                  posterWidth,
                                  posterHeight,
                                  titleStyle,
                                  contentStyle,
                                  movieDataModel,
                                  state.isBookmarked ?? false,
                                ),
                              ],
                            ),
                          ),
                          _buildTopButtons(
                              state.isBookmarked ?? false, movieDataModel),
                        ],
                      ),
      ),
    );
  }

  Widget _buildBackdrop(
      double height, String title, MovieDetailModel movieDataModel) {
    return CachedNetworkImage(
      imageUrl: _imageUrl(movieDataModel.backdropPath),
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildShimmer(height),
      errorWidget: (context, url, error) => Container(
        height: height * 0.8,
        color: Colors.grey.shade900,
        child: Center(
            child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }

  Widget _buildShimmer(double height) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      interval: const Duration(seconds: 0),
      color: Colors.grey.shade700,
      colorOpacity: 0.3,
      enabled: true,
      direction: ShimmerDirection.fromLTRB(),
      child: Container(
        width: double.infinity,
        height: height,
        color: Colors.grey.shade900,
      ),
    );
  }

  Widget _buildMovieInfo(
      double posterHeight,
      double posterWidth,
      double posterHeightFull,
      TextStyle titleStyle,
      TextStyle contentStyle,
      MovieDetailModel movieDataModel,
      bool isBookmarked) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          color: Colors.black,
          padding: EdgeInsets.fromLTRB(16, posterHeight / 2 + 24, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(movieDataModel.title ?? "No title", style: titleStyle),
              const SizedBox(height: 20),
              _buildRatingRow(movieDataModel),
              const SizedBox(height: 12),
              _buildReleaseDateRow(movieDataModel),
              const SizedBox(height: 20),
              _buildGenresSection(movieDataModel),
              const SizedBox(height: 20),
              _buildAdditionalInfo(contentStyle, movieDataModel),
              const SizedBox(height: 20),
              _buildOverviewCard(contentStyle, movieDataModel),
            ],
          ),
        ),
        Positioned(
          top: -posterHeight / 2,
          left: 16,
          child: Hero(
            tag: 'movie-poster-${movieDataModel.id}',
            child: _buildPosterImage(posterWidth, posterHeightFull,
                movieDataModel.title ?? "N/A", movieDataModel),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRow(MovieDetailModel movieDataModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.star, color: _iconColors[0], size: 22),
        const SizedBox(width: 6),
        const Text(
          'Rating:',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(width: 6),
        Text(
          '${movieDataModel.voteAverage?.toStringAsFixed(1) ?? "N/A"} / 10',
          style: const TextStyle(
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        const SizedBox(width: 10),
        Text(
          '(${movieDataModel.voteCount?.toInt() ?? "N/A"} votes)',
          style: const TextStyle(
              color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildReleaseDateRow(MovieDetailModel movieDataModel) {
    return Row(
      children: [
        const Text(
          "Release Date",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(width: 4),
        Icon(Icons.calendar_today, color: _iconColors[1], size: 20),
        const SizedBox(width: 4),
        Text(movieDataModel.releaseDate ?? "Unknown date",
            style: const TextStyle(color: Colors.white70, fontSize: 16)),
      ],
    );
  }

  Widget _buildGenresSection(MovieDetailModel movieDataModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Genres",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: (movieDataModel.genres ?? []).map((genere) {
            final genreName = genere.name;
            return _buildGenreChip(genreName ?? "");
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenreChip(String genreName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey.shade800.withOpacity(0.4),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.movie_filter_rounded, size: 16, color: _iconColors[2]),
          const SizedBox(width: 6),
          Text(
            genreName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(
      TextStyle contentStyle, MovieDetailModel movieDetailModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoItem(Icons.title, "Original Title",
            movieDetailModel.originalTitle ?? "N/A", _iconColors[0]),
        const SizedBox(height: 10),
        _infoItem(Icons.language, "Language",
            _languageName(movieDetailModel.originalLanguage), _iconColors[1]),
        const SizedBox(height: 10),
        _buildPopularityRow(movieDetailModel),
        const SizedBox(height: 12),
        _infoItem(
            Icons.warning,
            "Adult",
            movieDetailModel.adult == true ? "Yes (18+)" : "No",
            _iconColors[3]),
      ],
    );
  }

  Widget _buildPopularityRow(MovieDetailModel movieDataModel) {
    return Row(
      children: [
        Icon(Icons.trending_up, color: _iconColors[2], size: 20),
        const SizedBox(width: 6),
        const Text('Popularity:',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16)),
        const SizedBox(width: 6),
        Text(
          movieDataModel.popularity?.toStringAsFixed(1) ?? "N/A",
          style: const TextStyle(
              color: Colors.lightGreenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
      TextStyle contentStyle, MovieDetailModel movieDetailModel) {
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: _iconColors[0]),
                const SizedBox(width: 8),
                const Text(
                  "Overview",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              movieDetailModel.overview ?? "No overview available.",
              style: contentStyle,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPosterImage(double width, double height, String title,
      MovieDetailModel movieDetailModel) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: CachedNetworkImage(
        imageUrl: _imageUrl(movieDetailModel.posterPath),
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildShimmer(height),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade900,
          child: Center(
              child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Widget _buildTopButtons(
      bool isBookmarked, MovieDetailModel movieDetailModel) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCircleIconButton(
              icon: Icons.arrow_back,
              iconColor: Colors.white,
              backgroundColor: Colors.black.withOpacity(0.5),
              onPressed: () => context.pushReplacement('/baseScreen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: IconButton(
        icon: Icon(icon, color: iconColor),
        onPressed: onPressed,
      ),
    );
  }

  Widget _infoItem(
      IconData icon, String label, String content, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(
          child: Text(
            content,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
