import 'package:flutter/material.dart';
import 'package:musiq/src/features/home/domain/model/aura_song_list_model.dart';
import 'package:musiq/src/features/home/domain/model/recent_song_model.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../common_widgets/container/custom_color_container.dart';
import '../../../../../constants/color.dart';
import '../../../../../constants/style.dart';
import '../../../../../routing/route_name.dart';
import '../../../../../utils/image_url_generate.dart';
import '../../../../../utils/navigation.dart';
import '../../../../player/domain/model/player_song_list_model.dart';
import '../../../domain/model/album_song_list_model.dart';
import '../../../domain/model/new_release_model.dart';
import '../../../domain/model/trending_hits_model.dart';
import '../../../view_all_status.dart';

class AlbumSongsList extends StatelessWidget {
  const AlbumSongsList({
    Key? key,
    this.trendingHitsModel,
    this.newReleaseModel,
    required this.status,
    this.recentlyPlayed,
    this.albumSongListModel,
    this.auraSongListModel,
  }) : super(key: key);
  final TrendingHitsModel? trendingHitsModel;
  final NewReleaseModel? newReleaseModel;
  final RecentlyPlayed? recentlyPlayed;
  final AlbumSongListModel? albumSongListModel;
  final AuraSongListModel? auraSongListModel;
  final ViewAllStatus status;
  int getListCount(
    ViewAllStatus status,
  ) {
    switch (status) {
      case ViewAllStatus.newRelease:
        return newReleaseModel!.records.length;
      case ViewAllStatus.recentlyPlayed:
        return recentlyPlayed!.records.length;
      case ViewAllStatus.trendingHits:
        return trendingHitsModel!.records.length;
      case ViewAllStatus.album:
        return albumSongListModel!.totalrecords;

      case ViewAllStatus.aura:
        return auraSongListModel!.records.length;
      default:
        return 0;
    }
  }

  int getSongId(ViewAllStatus status, int index) {
    switch (status) {
      case ViewAllStatus.newRelease:
        return newReleaseModel!.records[index].id;
      case ViewAllStatus.recentlyPlayed:
        return recentlyPlayed!.records[index][0].id;
      case ViewAllStatus.trendingHits:
        return trendingHitsModel!.records[index].id;
      case ViewAllStatus.album:
        return albumSongListModel!.records[index].id;
      case ViewAllStatus.aura:
        return int.parse(
            auraSongListModel!.records[index].auraSongs.songId.toString());
      default:
        return 0;
    }
  }

  getImageUrl(ViewAllStatus status, int index) {
    switch (status) {
      case ViewAllStatus.newRelease:
        return generateSongImageUrl(newReleaseModel!.records[index].albumName,
            newReleaseModel!.records[index].albumId);
      case ViewAllStatus.recentlyPlayed:
        return generateSongImageUrl(recentlyPlayed!.records[index][0].albumName,
            recentlyPlayed!.records[index][0].albumId);
      case ViewAllStatus.trendingHits:
        return generateSongImageUrl(trendingHitsModel!.records[index].albumName,
            trendingHitsModel!.records[index].albumId);
      case ViewAllStatus.album:
        return generateSongImageUrl(
            albumSongListModel!.records[index].albumName,
            albumSongListModel!.records[index].albumId);
      case ViewAllStatus.aura:
        return generateSongImageUrl(auraSongListModel!.records[index].albumName,
            auraSongListModel!.records[index].albumId);
      default:
        return 0;
    }
  }

  getMusicDirectorName(ViewAllStatus status, int index) {
    switch (status) {
      case ViewAllStatus.newRelease:
        return newReleaseModel!.records[index].musicDirectorName[0];

      case ViewAllStatus.recentlyPlayed:
        return recentlyPlayed!.records[index][0].musicDirectorName[0];
      case ViewAllStatus.trendingHits:
        return trendingHitsModel!.records[index].musicDirectorName[0];
      case ViewAllStatus.album:
        return albumSongListModel!.records[index].musicDirectorName[0];
      case ViewAllStatus.aura:
        return auraSongListModel!.records[index].musicDirectorName[0];
      default:
        return 0;
    }
  }

  getSongName(ViewAllStatus status, int index) {
    switch (status) {
      case ViewAllStatus.newRelease:
        return newReleaseModel!.records[index].songName;

      case ViewAllStatus.recentlyPlayed:
        return recentlyPlayed!.records[index][0].songName;
      case ViewAllStatus.trendingHits:
        return trendingHitsModel!.records[index].songName;
      case ViewAllStatus.album:
        return albumSongListModel!.records[index].songName;
      case ViewAllStatus.aura:
        return auraSongListModel!.records[index].songName;
      default:
        return 0;
    }
  }

  getAlbumName(ViewAllStatus status, int index) {
    switch (status) {
      case ViewAllStatus.newRelease:
        return newReleaseModel!.records[index].albumName;

      case ViewAllStatus.recentlyPlayed:
        return recentlyPlayed!.records[index][0].albumName;
      case ViewAllStatus.trendingHits:
        return trendingHitsModel!.records[index].albumName;
      case ViewAllStatus.album:
        return albumSongListModel!.records[index].albumName;

      case ViewAllStatus.aura:
        return auraSongListModel!.records[index].albumName;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(childCount: getListCount(status),
          (context, index) {
        return SongListTile(
          albumName: getAlbumName(status, index),
          imageUrl: getImageUrl(status, index),
          musicDirectorName: getMusicDirectorName(status, index),
          songName: getSongName(status, index),
          songId: getSongId(status, index),
        );
      }),
    );
  }
}

class SongListTile extends StatelessWidget {
  const SongListTile(
      {super.key,
      required this.imageUrl,
      required this.songName,
      required this.musicDirectorName,
      required this.songId,
      required this.albumName});
  final String imageUrl;
  final String songName;
  final String albumName;
  final String musicDirectorName;
  final int songId;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CustomColorContainer(
                  child: Image.network(
                    imageUrl,
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
                          songName,
                          style: fontWeight400(),
                        ),
                        Text(
                          musicDirectorName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: fontWeight400(
                              size: 12.0, color: CustomColor.subTitle),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  child: PopupMenuButton<int>(
                color: CustomColor.appBarColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                onSelected: (value) {
                  switch (value) {
                    case 1:
                      context.read<PlayerProvider>().addFavourite(songId);
                      break;
                    case 2:
                      Navigation.navigateToScreen(
                          context, RouteName.addPlaylist,
                          args: songId.toString());
                      break;

                    case 3:
                      break;
                    case 4:
                      PlayerSongListModel playerSongListModel =
                          PlayerSongListModel(
                              id: songId,
                              albumName: albumName,
                              title: songName,
                              imageUrl: imageUrl,
                              musicDirectorName: musicDirectorName);
                      Navigation.navigateToScreen(context, RouteName.songInfo,
                          args: playerSongListModel);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Add to Favourites'),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text('Add to Playlist'),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text('Play next'),
                    ),
                    const PopupMenuItem(
                      value: 4,
                      child: Text('Song info'),
                    ),
                  ];
                },
              ))
              // Expanded(
              //     child: Padding(
              //   padding: const EdgeInsets.only(right: 0.0),
              //   child: Align(
              //     alignment: Alignment.centerRight,
              //     child: PopupMenuButton(
              // color: CustomColor.appBarColor,
              // shape: const RoundedRectangleBorder(
              //   borderRadius: BorderRadius.only(
              //     bottomLeft: Radius.circular(8.0),
              //     bottomRight: Radius.circular(8.0),
              //     topLeft: Radius.circular(8.0),
              //     topRight: Radius.circular(8.0),
              //   ),
              // ),
              //       // onSelected: (value) {
              //       //   _onMenuItemSelected(value as int);
              //       // },
              //       itemBuilder: (ctx) {
              //         PlayerSongListModel playerSongListModel =
              //             PlayerSongListModel(
              //                 id: record[index]!.id,
              //                 albumName: record[index]!.albumName,
              //                 title: record[index]!.songName,
              //                 imageUrl: generateSongImageUrl(
              //                     record[index]!.albumName,
              //                     record[index]!.albumId),
              //                 musicDirectorName: record[index]!
              //                     .musicDirectorName![0]
              //                     .toString());
              //         return [
              //           _buildPopupMenuItem('Add to Favourites',
              //               playerSongListModel, context),
              //           _buildPopupMenuItem('Add to Playlist',
              //               playerSongListModel, context),
              //           _buildPopupMenuItem(
              //               'Play next', playerSongListModel, context),
              //           _buildPopupMenuItem('Add to queue',
              //               playerSongListModel, context),
              //           _buildPopupMenuItem(
              //               'Song info', playerSongListModel, context),
              //         ];
              //       },
              //     ),
              //   ),
              // ))
            ],
          ),
        ));
  }
}
