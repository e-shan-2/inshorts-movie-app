import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inshort_app/data/models/movie_model.dart';
import 'package:inshort_app/presentation/widgets/movie_card_shimmer.dart';

import 'package:inshort_app/presentation/widgets/movie_image_card.dart';
import 'package:inshort_app/presentation/widgets/shimmer.dart';


class MovieHorizontalList extends StatelessWidget {
  final List<MovieModel> movies;
  final bool isLoading;
  final String? error;

  const MovieHorizontalList({
    super.key,
    required this.movies,
    this.isLoading = false,
    this.error,
  });

  @override
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Calculate height dynamically based on parent's width (or any logic)
      final height = constraints.maxWidth / 2; // Adjust ratio as needed

      if (isLoading) {
        return SizedBox(
          height: height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            // padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (_, __) => AspectRatio(
               aspectRatio: 0.75,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const CustomShimmer(),
              ),
            ),
          ),
        );
      }

      if (error != null && error!.isNotEmpty) {
        return SizedBox(
          height: height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Error: $error",
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }

      if (movies.isEmpty && !isLoading) {
        return SizedBox(
          height: height,
          child: const Center(
            child: Text(
              "No movies found",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }

      return SizedBox(
        height: height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          // padding: const EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (context, index) {
            final movie = movies[index];
            return AspectRatio(
              aspectRatio: 0.75,
              child: Padding(
                   padding: const EdgeInsets.all(8.0),
                child: MovieImageCard(
                  title:movie.title??"N/A" ,
                  onTap: () => context.push('/movieDetails', extra: movie),
                  imageUrl: movie.posterPath ?? "",
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

}
