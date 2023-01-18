import 'package:flutter/material.dart';
import 'package:musiq/src/features/home/provider/artist_view_all_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../constants/color.dart';
import '../../../../constants/style.dart';
import '../../../../utils/image_url_generate.dart';

class AlbumSongsList extends StatelessWidget {
  const AlbumSongsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistViewAllProvider>(builder: (context, pro, _) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
            childCount: pro.collectionViewAllModel.totalrecords,
            (context, index) {
          var record = pro.collectionViewAllModel.records;
          return DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomColorContainer(
                        child: Image.network(
                          generateSongImageUrl(
                              record[index]!.albumName, record[index]!.albumId),
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record[index]!.songName,
                                style: fontWeight400(),
                              ),
                              Text(
                                "${record[index]!.albumName} - ${record[index]!.musicDirectorName![0]}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: fontWeight400(
                                    size: 12.0, color: CustomColor.subTitle),
                              ),
                            ],
                          ),
                        )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: PopupMenuButton(
                          color: CustomColor.appBarColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                          ),
                          // onSelected: (value) {
                          //   _onMenuItemSelected(value as int);
                          // },
                          itemBuilder: (ctx) => [
                            // _buildPopupMenuItem('Play next'),
                            //   _buildPopupMenuItem('Add to queue'),
                            //   _buildPopupMenuItem('Remove'),
                            //   _buildPopupMenuItem('Song info'),
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              ));
        }),
      );
    });
  }
}
