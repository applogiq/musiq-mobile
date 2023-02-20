import 'package:flutter/material.dart';
import 'package:musiq/src/features/home/screens/sliver_app_bar/widgets/song_list_tile.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enums/enums.dart';
import '../../../../../core/utils/url_generate.dart';
import '../../../domain/model/album_song_list_model.dart';
import '../../../domain/model/aura_song_list_model.dart';
import '../../../domain/model/collection_view_all_model.dart';
import '../../../domain/model/new_release_model.dart';
import '../../../domain/model/recent_song_model.dart';
import '../../../domain/model/trending_hits_model.dart';
import '../../../provider/view_all_provider.dart';

class AlbumSongsList extends StatelessWidget {
  const AlbumSongsList({
    Key? key,
    this.trendingHitsModel,
    this.newReleaseModel,
    required this.status,
    this.recentlyPlayed,
    this.albumSongListModel,
    this.auraSongListModel,
    this.collectionViewAllModel,
  }) : super(key: key);

  final AlbumSongListModel? albumSongListModel;
  final AuraSongListModel? auraSongListModel;
  final CollectionViewAllModel? collectionViewAllModel;
  final NewReleaseModel? newReleaseModel;
  final RecentlyPlayed? recentlyPlayed;
  final ViewAllStatus status;
  final TrendingHitsModel? trendingHitsModel;

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
      case ViewAllStatus.artist:
        return collectionViewAllModel!.records.length;
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
      case ViewAllStatus.artist:
        return collectionViewAllModel!.records[index]!.id;
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
      case ViewAllStatus.artist:
        return generateSongImageUrl(
            collectionViewAllModel!.records[index]!.albumName,
            collectionViewAllModel!.records[index]!.albumId);
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
      case ViewAllStatus.artist:
        return collectionViewAllModel!.records[index]!.musicDirectorName![0];
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
      case ViewAllStatus.artist:
        return collectionViewAllModel!.records[index]!.songName;
      default:
        return 0;
    }
  }

  getDuration(ViewAllStatus status, int index) {
    switch (status) {
      case ViewAllStatus.newRelease:
        return newReleaseModel!.records[index].duration;

      case ViewAllStatus.recentlyPlayed:
        return recentlyPlayed!.records[index][0].duration;
      case ViewAllStatus.trendingHits:
        return trendingHitsModel!.records[index].duration;
      case ViewAllStatus.album:
        return albumSongListModel!.records[index].duration;
      case ViewAllStatus.aura:
        return auraSongListModel!.records[index].duration;
      case ViewAllStatus.artist:
        return collectionViewAllModel!.records[index]!.duration;
      default:
        return "0";
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
      case ViewAllStatus.artist:
        return collectionViewAllModel!.records[index]!.albumName;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(childCount: getListCount(status),
          (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              context
                  .read<ViewAllProvider>()
                  .navigateToPlayerScreen(context, status, index: index);
            },
            child: SongListTile(
              isPremium: index == 1 ? true : false,
              albumName: getAlbumName(status, index),
              imageUrl: getImageUrl(status, index),
              musicDirectorName: getMusicDirectorName(status, index),
              songName: getSongName(status, index),
              songId: getSongId(status, index),
              duration: getDuration(status, index),
              isPlay: false,
            ),
          ),
        );
      }),
    );
  }
}
