import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../constants/color.dart';
import '../../../../constants/style.dart';
import '../../../../routing/route_name.dart';
import '../../../../utils/image_url_generate.dart';
import '../../../../utils/navigation.dart';
import '../../../player/domain/model/player_song_list_model.dart';
import '../../../player/provider/player_provider.dart';
import '../../provider/artist_view_all_provider.dart';

class AlbumSongsList extends StatelessWidget {
  const AlbumSongsList({
    Key? key,
  }) : super(key: key);

  PopupMenuItem _buildPopupMenuItem(String title,
      PlayerSongListModel playerSongListModel, BuildContext context,
      {int position = 0}) {
    return PopupMenuItem(
      value: position,
      child: InkWell(
          onTap: () {
            if (title == "Song info") {
              Navigator.pop(context);
              Navigation.navigateToScreen(context, RouteName.songInfo,
                  args: playerSongListModel);
            } else if (title == "Add to Playlist") {
              Navigator.pop(context);
              Navigation.navigateToScreen(context, RouteName.addPlaylist,
                  args: playerSongListModel.id.toString());
            } else if (title == "Add to Favourites") {
              Navigator.pop(context);
              context
                  .read<PlayerProvider>()
                  .addFavourite(playerSongListModel.id);
            }
          },
          child: Text(title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistViewAllProvider>(builder: (context, pro, _) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
            childCount: pro.collectionViewAllModel.totalrecords,
            (context, index) {
          var record = pro.collectionViewAllModel.records;
          return InkWell(
            onTap: () {
              List<PlayerSongListModel> playerSongList = [];

              for (var record in pro.collectionViewAllModel.records) {
                playerSongList.add(PlayerSongListModel(
                    id: record!.id,
                    albumName: record.albumName.toString(),
                    title: record.songName.toString(),
                    imageUrl:
                        generateSongImageUrl(record.albumName, record.albumId),
                    musicDirectorName:
                        record.musicDirectorName![0].toString()));
              }
              context
                  .read<PlayerProvider>()
                  .goToPlayer(context, playerSongList, index);
            },
            child: DecoratedBox(
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
                            generateSongImageUrl(record[index]!.albumName,
                                record[index]!.albumId),
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
                        padding: const EdgeInsets.only(right: 0.0),
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
                            itemBuilder: (ctx) {
                              PlayerSongListModel playerSongListModel =
                                  PlayerSongListModel(
                                      id: record[index]!.id,
                                      albumName: record[index]!.albumName,
                                      title: record[index]!.songName,
                                      imageUrl: generateSongImageUrl(
                                          record[index]!.albumName,
                                          record[index]!.albumId),
                                      musicDirectorName: record[index]!
                                          .musicDirectorName![0]
                                          .toString());
                              return [
                                _buildPopupMenuItem('Add to Favourites',
                                    playerSongListModel, context),
                                _buildPopupMenuItem('Add to Playlist',
                                    playerSongListModel, context),
                                _buildPopupMenuItem(
                                    'Play next', playerSongListModel, context),
                                _buildPopupMenuItem('Add to queue',
                                    playerSongListModel, context),
                                _buildPopupMenuItem(
                                    'Song info', playerSongListModel, context),
                              ];
                            },
                          ),
                        ),
                      ))
                    ],
                  ),
                )),
          );
        }),
      );
    });
  }
}
