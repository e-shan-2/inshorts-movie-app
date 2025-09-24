import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MovieCardShimmer extends StatelessWidget {
  const MovieCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Darker grey colors for shimmer on black background
    final baseColor = Colors.grey.shade800; // darker grey for base
    final highlightColor = Colors.grey.shade700; // lighter grey for shimmer highlight

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.black, // Card background black
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Shimmer(
          duration: const Duration(seconds: 2),
          interval: const Duration(seconds: 0),
          color: highlightColor,
          colorOpacity: 0.5,
          enabled: true,
          direction: ShimmerDirection.fromLeftToRight(),
          child: Row(
            children: [
              // Poster shimmer box with base color
              Container(
                width: 100,
                height: 150,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              const SizedBox(width: 12),

              // Text shimmer boxes for title, adult badge & overview
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 20, width: double.infinity, color: baseColor),
                    const SizedBox(height: 8),
                    Container(height: 16, width: 30, color: baseColor),
                    const SizedBox(height: 12),
                    Container(height: 14, width: double.infinity, color: baseColor),
                    const SizedBox(height: 6),
                    Container(height: 14, width: double.infinity, color: baseColor),
                    const SizedBox(height: 6),
                    Container(height: 14, width: 150, color: baseColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
