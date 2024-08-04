import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomImageNetwork extends StatelessWidget {
  const CustomImageNetwork({
    super.key,
    required this.imageUrl,
    this.height = 150,
    this.width = 150,
    this.borderRadius = 12,
  });

  final String imageUrl;
  final double height;
  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fill,
      placeholder: (context, url) => const CupertinoActivityIndicator(),
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.error,
      ),
    );
  }
}
