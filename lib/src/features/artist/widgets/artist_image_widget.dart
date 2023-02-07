import 'package:flutter/material.dart';

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
    );
  }
}
