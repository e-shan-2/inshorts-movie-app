import 'package:flutter/material.dart';

class NoContentWidget extends StatelessWidget {
  final String? title;
  const NoContentWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title ?? "No movies found.",
        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
      ),
    );
  }
}
