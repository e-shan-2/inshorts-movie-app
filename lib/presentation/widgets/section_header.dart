import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const SectionHeader({super.key, required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white)),
          if (onViewAll != null)
            IconButton(
              onPressed: onViewAll,
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
