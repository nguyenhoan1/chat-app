import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerItemLoading extends StatelessWidget {
  final double height;
  final double width;

  const ShimmerItemLoading(
      {super.key, required this.height, required this.width});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        title: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
