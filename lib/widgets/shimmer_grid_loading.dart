
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerGridLoading extends StatelessWidget {
  const ShimmerGridLoading({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the background and card colors from your theme
    final baseColor = Theme.of(context).colorScheme.surface; // Use surface for base
    final highlightColor = baseColor;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Card(
        // Card theme is applied globally
        margin: const EdgeInsets.all(4.0), // Match grid item margin
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Placeholder for Image
            Expanded(
              child: Container(
                color: Colors.white, // Shimmer effect color
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder for Title
                  Container(
                    width: double.infinity,
                    height: 14.0, // Match text height
                    color: Colors.white, // Shimmer effect color
                  ),
                  const SizedBox(height: 4.0),
                  // Placeholder for Price
                  Container(
                    width: 60.0, // Shorter width for price placeholder
                    height: 12.0, // Match text height
                    color: Colors.white, // Shimmer effect color
                  ),
                  // Placeholder for Description (optional in grid)
                  // const SizedBox(height: 4.0),
                  // Container(
                  //   width: double.infinity,
                  //   height: 10.0,
                  //   color: Colors.white,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
