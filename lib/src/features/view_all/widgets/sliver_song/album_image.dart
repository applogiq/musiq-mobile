import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/utils/url_generate.dart';

class AlbumImage extends StatelessWidget {
  const AlbumImage({
    Key? key,
    required this.padding,
    required this.animateOpacityToZero,
    required this.animateAlbumImage,
    required this.shrinkToMaxAppBarHeightRatio,
    required this.albumImageSize,
    required this.id,
    required this.isImage,
    required this.albumName,
    required this.albumId,
    required this.label,
  }) : super(key: key);

  final String albumId;
  final double albumImageSize;
  final String albumName;
  final bool animateAlbumImage;
  final bool animateOpacityToZero;
  final String id;
  final bool isImage;
  final String label;
  final EdgeInsets padding;
  final double shrinkToMaxAppBarHeightRatio;

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
              color:
                  isImage ? Colors.deepPurpleAccent : CustomColor.defaultCard,
              image: isImage
                  ? DecorationImage(
                      image: NetworkImage(
                          generateSongImageUrl(albumName, albumId)),
                      fit: BoxFit.fill,
                    )
                  : DecorationImage(
                      image: AssetImage(Images.noArtist),
                      fit: BoxFit.fill,
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
