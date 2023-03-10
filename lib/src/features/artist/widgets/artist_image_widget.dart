import 'package:flutter/material.dart';
import 'package:musiq/src/core/constants/images.dart';

class ArtistImagesWidget extends StatelessWidget {
  const ArtistImagesWidget({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: 80,
      height: 80,
      fit: BoxFit.fill,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        Images.noArtist,
        width: 80,
        height: 80,
        fit: BoxFit.fill,
      ),
    );
  }
}
