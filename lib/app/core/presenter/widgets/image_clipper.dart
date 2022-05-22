import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ClippedImage extends StatelessWidget {
  const ClippedImage(
    this.image, {
    this.fit,
    this.height = 65,
    this.width = 65,
    Key? key,
  }) : super(key: key);

  final String image;
  final BoxFit? fit;
  final double width, height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 1,
        child: CachedNetworkImage(
          imageUrl: image,
          fit: fit ?? BoxFit.cover,
          height: height,
          width: width,
        ),
      ),
    );
  }
}
