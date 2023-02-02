import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/constant.dart';
import '../../../../utils/image_url_generate.dart';
import '../../../../utils/size_config.dart';
import '../../provider/player_provider.dart';

class SongInfoCover extends StatelessWidget {
  const SongInfoCover({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(350),
      child: Stack(
        children: [
          Image.network(
            generateSongImageUrl(
                context
                    .read<PlayerProvider>()
                    .songInfoModel!
                    .records
                    .albumDetails
                    .albumName,
                context
                    .read<PlayerProvider>()
                    .songInfoModel!
                    .records
                    .albumDetails
                    .albumId),
            fit: BoxFit.cover,
            height: getProportionateScreenHeight(350),
            width: double.maxFinite,
          ),
          Container(
            height: getProportionateScreenHeight(350),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.7)
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                context.read<PlayerProvider>().songInfoModel!.records.songName,
                style: fontWeight600(size: 24.0),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    // color: color2,

                    size: 18,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
