import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_color.dart';

class CustomImageNetwork extends StatelessWidget {
  const CustomImageNetwork({
    super.key,
    required this.imageUrl,
    this.height = 150,
    this.width = 150,
    this.borderRadius = 12,
    this.useParticularBorderRadius = false,
    this.bottomRight = 0,
    this.bottomLeft = 0,
    this.topLeft = 0,
    this.topRight = 0,
  });

  final String imageUrl;
  final double height;
  final double width;
  final double borderRadius;
  final bool useParticularBorderRadius;
  final double bottomRight;
  final double bottomLeft;
  final double topLeft;
  final double topRight;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fill,
      placeholder: (context, url) => Container(
        height: height,
        width: width,
        child: const Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          borderRadius: useParticularBorderRadius
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(bottomLeft),
                  bottomRight: Radius.circular(bottomRight),
                  topLeft: Radius.circular(topLeft),
                  topRight: Radius.circular(topRight),
                )
              : BorderRadius.circular(borderRadius),
        ),
      ),
      errorWidget: (context, url, error) {
        print('error url $error');
        return Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          child: Icon(
            Icons.broken_image,
            color: AppColor.grayColor,
          ),
        );
      },
    );
  }
}
