import 'package:flutter/material.dart';
import 'package:inshort_app/presentation/widgets/shimmer.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeScreenSimmer extends StatelessWidget {
  const HomeScreenSimmer({super.key});

  Widget _simmerBox({double width = double.infinity, double height = 20, BorderRadius? borderRadius}) {
    return Shimmer(
    duration: const Duration(seconds: 2),
    interval: const Duration(seconds: 0),
    color: Colors.grey.shade700,
    colorOpacity: 0.3,
    enabled: true,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Trending Section Header shimmer
          _simmerBox(width: 150, height: 25, borderRadius: BorderRadius.circular(10)),

          const SizedBox(height: 10),

          // Trending movies shimmer list
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, __) => _simmerBox(width: 140, height: 180, borderRadius: BorderRadius.circular(12)),
            ),
          ),

          const SizedBox(height: 20),

          // Now Playing Section Header shimmer
          _simmerBox(width: 180, height: 25, borderRadius: BorderRadius.circular(10)),

          const SizedBox(height: 10),

          // Now Playing movies shimmer list
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, __) => AspectRatio(
                
                aspectRatio: 1/4,
                child: CustomShimmer()),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
