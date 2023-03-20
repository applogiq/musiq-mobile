import 'package:flutter/material.dart';
import 'package:musiq/src/core/constants/images.dart';
import 'package:musiq/src/core/extensions/string_extension.dart';
import 'package:musiq/src/features/auth/provider/login_provider.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../core/constants/constant.dart';
import '../../../core/enums/enums.dart';
import '../../../core/utils/url_generate.dart';
import '../domain/model/album_model.dart';
import '../provider/view_all_provider.dart';
import '../screens/sliver_app_bar/view_all_screen.dart';

class TopAlbum extends StatelessWidget {
  const TopAlbum({super.key, required this.album});
  final Album album;

  bool getPremiumStatus(BuildContext context, Record record, int index) {
    // album.records[index]
    if (record.premiumStatus == "premium" &&
        context.read<LoginProvider>().userModel!.records.premiumStatus ==
            "free") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return album.totalrecords == 0
        ? const SizedBox.shrink()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: const [
                    Text(
                      "Top Albums",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                height: 200,
                child: ListView.builder(
                    // reverse: true,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: album.records.length,
                    itemBuilder: (context, index) => Row(
                          children: [
                            index == 0
                                ? const SizedBox(
                                    width: 10,
                                  )
                                : const SizedBox(),
                            Container(
                              padding: const EdgeInsets.fromLTRB(6, 8, 6, 0),
                              width: 135,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<ViewAllProvider>()
                                          .loaderEnable();
                                      if (album.records[index].noOfSongs == 0) {
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => ViewAllScreen(
                                                    status: ViewAllStatus.album,
                                                    id: album.records[index].id,
                                                    isPremium: getPremiumStatus(
                                                        context,
                                                        album.records[index],
                                                        index)
                                                    // index == 1 ? true : false,
                                                    )));
                                      }
                                    },
                                    child: CustomColorContainer(
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          album.records[index].isImage == false
                                              ? Image.asset(
                                                  Images.noArtist,
                                                  height: 125,
                                                  width: 135,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  generateSongImageUrl(
                                                      album.records[index]
                                                          .albumName,
                                                      album.records[index]
                                                          .albumId),
                                                  height: 125,
                                                  width: 135,
                                                  fit: BoxFit.fill,
                                                ),
                                          (getPremiumStatus(context,
                                                  album.records[index], index))
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor:
                                                        CustomColor.bg,
                                                    child: Image.asset(
                                                      Images.crownImage,
                                                      height: 21,
                                                      width: 21,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink()
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    album.records[index].albumName
                                        .toString()
                                        .capitalizeFirstLetter(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                      album.records[index].musicDirectorName
                                              .isEmpty
                                          ? ""
                                          : album.records[index]
                                              .musicDirectorName[0]
                                              .toString()
                                              .capitalizeFirstLetter(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: fontWeight400(
                                          size: 12.0,
                                          color: CustomColor.subTitle))
                                ],
                              ),
                            ),
                          ],
                        )),
              ),
            ],
          );
  }
}
