import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Shimmer(
        duration: const Duration(seconds: 2),
        interval: const Duration(seconds: 0),
        color: Colors.grey.shade700,
        colorOpacity: 0.3,
        enabled: true,
        direction: ShimmerDirection.fromLTRB(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }
}
