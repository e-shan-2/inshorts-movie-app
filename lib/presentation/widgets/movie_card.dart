import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MovieCard extends StatefulWidget {
  final String title;
  final String overview;
  final String posterPath;
  final bool adult;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkToggle;
  final Widget ?bookMarkWidget;

  const MovieCard({
    Key? key,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.adult,
    this.isBookmarked = false,
    this.onTap,
    this.onBookmarkToggle,
    this.bookMarkWidget,
  }) : super(key: key);

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool isExpanded = false;

  void toggleReadMore() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = "https://image.tmdb.org/t/p/original/${widget.posterPath}";

    return Stack(
      children: [
        /// Movie Card
        Card(
          elevation: 3,
          color: const Color(0xFF1E1E1E),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    /// Movie Poster
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer(
                          duration: const Duration(seconds: 2),
                          interval: const Duration(seconds: 0),
                          color: Colors.grey.shade800,
                          colorOpacity: 0.2,
                          enabled: true,
                          direction: ShimmerDirection.fromLTRB(),
                          child: Container(
                            width: 100,
                            height: 150,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 100,
                          height: 150,
                          color: Colors.grey.shade900,
                          child: const Icon(Icons.broken_image,
                              color: Colors.white54),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// Movie Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Title + Adult Badge
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.adult)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    "18+",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          /// Overview Text
                          AnimatedCrossFade(
                            firstChild: Text(
                              widget.overview,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            secondChild: Text(
                              widget.overview,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            crossFadeState: isExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 200),
                          ),

                          const SizedBox(height: 6),

                          GestureDetector(
                            onTap: toggleReadMore,
                            child: Text(
                              isExpanded ? "Read Less" : "Read More",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        /// Bookmark Icon (top-right)
        Positioned(
          top: -10,
          right: 10,
          child: GestureDetector(
            onTap: widget.onBookmarkToggle,
            child:widget.bookMarkWidget
            //  IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     widget.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            //     color: Colors.white,
            //     size: 28,
            //   ),
            // ),
          ),
        ),
      ],
    );
  }
}
