import 'package:flutter/material.dart';

import '../../../../../core/constants/color.dart';
import '../../../../../core/constants/images.dart';

class ExpandedAppBar extends StatelessWidget {
  const ExpandedAppBar({
    Key? key,
    required this.padding,
    required this.animateOpacityToZero,
    required this.animateAlbumImage,
    required this.shrinkToMaxAppBarHeightRatio,
    required this.albumImageSize,
    required this.imageUrl,
  }) : super(key: key);

  final EdgeInsets padding;
  final bool animateOpacityToZero;
  final bool animateAlbumImage;
  final double shrinkToMaxAppBarHeightRatio;
  final double albumImageSize;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: animateOpacityToZero
              ? 0
              : animateAlbumImage
                  ? 1 - shrinkToMaxAppBarHeightRatio
                  : 1,
          child: Container(
            height: albumImageSize,
            width: albumImageSize,
            decoration: BoxDecoration(
              color: imageUrl != ""
                  ? Colors.deepPurpleAccent
                  : CustomColor.defaultCard,
              image: imageUrl != ""
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: AssetImage(Images.noArtist),
                      fit: BoxFit.cover,
                    ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  spreadRadius: 1,
                  blurRadius: 50,
                ),
              ],
            ),
          ),
        ));
  }
}
