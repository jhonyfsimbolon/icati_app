import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class BeritaDukaPhoto extends StatelessWidget {
  BeritaDukaPhoto({this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(imageUrl),
        initialScale: PhotoViewComputedScale.contained * 1,
        minScale: PhotoViewComputedScale.contained * 1,
        maxScale: 4.0,
      ),
    );
  }
}
