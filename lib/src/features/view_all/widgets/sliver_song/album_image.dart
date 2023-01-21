import 'package:flutter/material.dart';
import 'package:musiq/src/utils/image_url_generate.dart';

import '../../../../constants/color.dart';
import '../../../../constants/images.dart';

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

  final EdgeInsets padding;
  final bool animateOpacityToZero;
  final bool animateAlbumImage;
  final double shrinkToMaxAppBarHeightRatio;
  final double albumImageSize;
  final String id;
  final String albumName;
  final String label;
  final String albumId;
  final bool isImage;

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
