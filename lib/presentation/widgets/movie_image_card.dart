import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MovieImageCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback? onTap; // optional tap callback

  const MovieImageCard({
    super.key,
    required this.imageUrl,
    this.onTap,
   required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = "https://image.tmdb.org/t/p/w500/$imageUrl";

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12), // ripple inside border
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
         
        CachedNetworkImage(
          imageUrl: imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) => Shimmer(
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
          errorWidget: (context, url, error) =>  Container(
              
            decoration: BoxDecoration(

   color: Colors.black,
     border: Border.all(
      color: Colors.white12, // 👈 Set your border color here
      width: 2.0,   
        
    ),
   borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(title ,
              textAlign:TextAlign.center,
              
               style: TextStyle(color: Colors.grey.shade500 , fontSize: 16 ,fontWeight: FontWeight.bold),)
            ),
          ),
        ),
        
            // Optional tap overlay effect (like slight dark overlay on press)
            if (onTap != null)
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    splashColor: Colors.white24,
                    highlightColor: Colors.black12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
