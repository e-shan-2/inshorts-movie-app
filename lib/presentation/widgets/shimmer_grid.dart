import 'package:flutter/material.dart';
import 'package:inshort_app/presentation/widgets/shimmer.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ShimmerGrid extends StatelessWidget {
  const ShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: 10,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (_, __) => CustomShimmer()
              
              ),
    );
  }
}
