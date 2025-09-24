import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inshort_app/core/constants/api_constants.dart';
import 'package:inshort_app/data/models/movie_model.dart';
import 'package:inshort_app/presentation/viewmodels/book_marks/book_mark_provider.dart';
import 'package:inshort_app/presentation/viewmodels/connectivity_provider.dart';
import 'package:inshort_app/services/internet_connectivity_services.dart';
import 'package:inshort_app/services/url_shortner.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:share_plus/share_plus.dart';

class MovieDetailPage extends ConsumerStatefulWidget {
  final MovieModel movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  ConsumerState<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends ConsumerState<MovieDetailPage> {
  static const _genreMap = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Science Fiction',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
  };

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(bookMarkProvider.notifier)
          .isBookMarkedOrNot(widget.movie.id ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookMarkProvider);
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

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildBackdrop(size.height * 0.45, widget.movie.title ?? "N/A"),
                _buildMovieInfo(posterHeight, posterWidth, posterHeight,
                    titleStyle, contentStyle, state.isBookmarked ?? false),
              ],
            ),
          ),
          _buildTopButtons(state.isBookmarked ?? false),
        ],
      ),
    );
  }

  Widget _buildBackdrop(double height, String title) {
    return CachedNetworkImage(
      imageUrl: _imageUrl(widget.movie.backdropPath),
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
        )

            // Icon(Icons.image_not_supported, size: 50, color: Colors.white54),
            ),
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
              Text(widget.movie.title ?? "No title", style: titleStyle),
              const SizedBox(height: 20),
              _buildRatingRow(),
              const SizedBox(height: 12),
              _buildReleaseDateRow(),
              const SizedBox(height: 20),
              _buildGenresSection(),
              const SizedBox(height: 20),
              _buildAdditionalInfo(contentStyle),
              const SizedBox(height: 20),
              _buildOverviewCard(contentStyle),
            ],
          ),
        ),
        Positioned(
          top: -posterHeight / 2,
          left: 16,
          child: Hero(
            tag: 'movie-poster-${widget.movie.id}',
            child: _buildPosterImage(
                posterWidth, posterHeightFull, widget.movie.title ?? "N/A"),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRow() {
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
          '${widget.movie.voteAverage?.toStringAsFixed(1) ?? "N/A"} / 10',
          style: const TextStyle(
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        const SizedBox(width: 10),
        Text(
          '(${widget.movie.voteCount?.toInt() ?? "N/A"} votes)',
          style: const TextStyle(
              color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildReleaseDateRow() {
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
        Text(widget.movie.releaseDate ?? "Unknown date",
            style: const TextStyle(color: Colors.white70, fontSize: 16)),
      ],
    );
  }

  Widget _buildGenresSection() {
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
          children: (widget.movie.genreIds ?? []).map((id) {
            final genreName = _genreMap[id] ?? 'Unknown';
            return _buildGenreChip(genreName);
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

  Widget _buildAdditionalInfo(TextStyle contentStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoItem(Icons.title, "Original Title",
            widget.movie.originalTitle ?? "N/A", _iconColors[0]),
        const SizedBox(height: 10),
        _infoItem(Icons.language, "Language",
            _languageName(widget.movie.originalLanguage), _iconColors[1]),
        const SizedBox(height: 10),
        _buildPopularityRow(),
        const SizedBox(height: 12),
        _infoItem(Icons.warning, "Adult",
            widget.movie.adult == true ? "Yes (18+)" : "No", _iconColors[3]),
        const SizedBox(height: 10),
        // _infoItem(Icons.how_to_vote, "Vote Count",
        //     '${widget.movie.voteCount ?? "N/A"}', _iconColors[4]),
      ],
    );
  }

  Widget _buildPopularityRow() {
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
          widget.movie.popularity?.toStringAsFixed(1) ?? "N/A",
          style: const TextStyle(
              color: Colors.lightGreenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(TextStyle contentStyle) {
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
              widget.movie.overview ?? "No overview available.",
              style: contentStyle,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPosterImage(double width, double height, String title) {
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
        imageUrl: _imageUrl(widget.movie.posterPath),
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildShimmer(height),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade900,
          child: Center(
              child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Widget _buildTopButtons(bool isBookmarked) {
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
              onPressed: () => context.pop(),
            ),
            _buildCircleIconButton(
              icon: isBookmarked
                  ? Icons.bookmark_added_rounded
                  : Icons.bookmark_add_outlined,
              iconColor: isBookmarked ? Colors.orange : Colors.white,
              backgroundColor: Colors.black.withOpacity(0.5),
              onPressed: () async {
                bool checkConnection = await CheckInternetConnection()
                    .checkInternetConnection(context);
                ref
                    .read(connectivityProvider.notifier)
                    .updateConnectionStatus(checkConnection);

                if (checkConnection) {
                  await ref
                      .read(bookMarkProvider.notifier)
                      .addBookmark(widget.movie);
                  await ref
                      .read(bookMarkProvider.notifier)
                      .isBookMarkedOrNot(widget.movie.id ?? 0);
                }
              },
            ),
            _buildCircleIconButton(
              iconColor: Colors.white,
              backgroundColor: Colors.black.withOpacity(0.5),
              icon: Icons.share,
              onPressed: () async {
                bool checkConnection = await CheckInternetConnection()
                    .checkInternetConnection(context);
                ref
                    .read(connectivityProvider.notifier)
                    .updateConnectionStatus(checkConnection);

                if (checkConnection) {
                  final String? shortUrl = await shortenUrlWithTinyUrl(
                    longUrl:
                        'inshortapp://blabla/movieDetailsScreen/${widget.movie.id}',
                    apiKey: ApiConstants.apiShortNerToken,
                  );

                  if (shortUrl != null) {
                    print('Shortened URL: $shortUrl');
                  } else {
                    print('Failed to shorten URL');
                  }

                  SharePlus.instance.share(
                    ShareParams(text: shortUrl ?? ""),
                  );
                }
              },
            )
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            content,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
                fontSize: 14),
          ),
        ),
      ],
    );
  }
}
