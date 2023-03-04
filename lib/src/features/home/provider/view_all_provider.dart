import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/enums.dart';
import '../../../core/utils/url_generate.dart';
import '../../player/domain/model/player_song_list_model.dart';
import '../../player/provider/player_provider.dart';
import '../domain/model/album_song_list_model.dart';
import '../domain/model/aura_song_list_model.dart';
import '../domain/model/collection_view_all_model.dart';
import '../domain/model/new_release_model.dart';
import '../domain/model/recent_song_model.dart';
import '../domain/model/trending_hits_model.dart';
import '../domain/repository/home_repo.dart';

class ViewAllProvider extends ChangeNotifier {
  bool isLoad = true;
  HomeRepository homeRepository = HomeRepository();
  TrendingHitsModel trendingHitsModel = TrendingHitsModel(
      success: false, message: "No records", records: [], totalrecords: 0);

  RecentlyPlayed recentlyPlayed = RecentlyPlayed(
      success: false, message: "No records", records: [], totalrecords: 0);

  NewReleaseModel newReleaseModel = NewReleaseModel(
      success: false, message: "No records", records: [], totalrecords: 0);
  AlbumSongListModel albumSongListModel = AlbumSongListModel(
      success: false, message: "No records", records: [], totalrecords: 0);

  AuraSongListModel auraSongListModel = AuraSongListModel(
      success: false, message: "No records", records: [], totalRecords: 0);
  CollectionViewAllModel collectionViewAllModel = CollectionViewAllModel(
      success: false, message: "No records", records: [], totalrecords: 0);

  loaderEnable() {
    isLoad = true;
    notifyListeners();
  }

  void getViewAll(ViewAllStatus status,
      {int? id,
      Function? function,
      bool goToNextfunction = false,
      BuildContext? context,
      int? index}) async {
    isLoad = true;
    notifyListeners();
    if (status == ViewAllStatus.trendingHits) {
      var res = await homeRepository.getTrendingSongList(100);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        trendingHitsModel = TrendingHitsModel.fromMap(data);
      }
    } else if (status == ViewAllStatus.newRelease) {
      print("sssssssssssssssss");
      var res = await homeRepository.getNewRelease();
      print("-------------------------");
      print(res.body);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        newReleaseModel = NewReleaseModel.fromMap(data);
      }
    } else if (status == ViewAllStatus.recentlyPlayed) {
      print("-------------------------");

      var res = await homeRepository.getRecentPlayedList(100);
      print(res.body);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        recentlyPlayed = RecentlyPlayed.fromMap(data);
      }
    } else if (status == ViewAllStatus.album) {
      var res = await homeRepository.getSpecificAlbum(id!);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        albumSongListModel = AlbumSongListModel.fromMap(data);
        notifyListeners();
      }
    } else if (status == ViewAllStatus.aura) {
      var res = await homeRepository.getSpecificAura(id!);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        auraSongListModel = AuraSongListModel.fromMap(data);
        notifyListeners();
      }
    } else if (status == ViewAllStatus.artist) {
      var res = await homeRepository.getSpecifArtistSong(id.toString());
      collectionViewAllModel = CollectionViewAllModel(
          success: false, message: "No records", records: [], totalrecords: 0);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        collectionViewAllModel = CollectionViewAllModel.fromMap(data);
        notifyListeners();
      }
    }
    if (goToNextfunction) {
      navigateToPlayerScreen(context!, status, index: index!);
    }
    isLoad = false;
    notifyListeners();
  }

  navigateToPlayerScreen(BuildContext context, ViewAllStatus viewAllStatus,
      {int index = 0}) async {
    List<PlayerSongListModel> playerSongList = [];
    switch (viewAllStatus) {
      case ViewAllStatus.newRelease:
        for (var record in newReleaseModel.records) {
          playerSongList.add(PlayerSongListModel(
              id: record.id,
              albumName: record.albumName.toString(),
              title: record.songName.toString(),
              imageUrl: generateSongImageUrl(record.albumName, record.albumId),
              musicDirectorName: record.musicDirectorName[0].toString(),
              duration: record.duration,
              premium: record.premiumStatus));
        }
        break;
      case ViewAllStatus.recentlyPlayed:
        for (var record in recentlyPlayed.records) {
          playerSongList.add(PlayerSongListModel(
              id: record[0].id,
              albumName: record[0].albumName.toString(),
              title: record[0].songName.toString(),
              imageUrl:
                  generateSongImageUrl(record[0].albumName, record[0].albumId),
              musicDirectorName: record[0].musicDirectorName[0].toString(),
              duration: record[0].duration,
              premium: record[0].premiumStatus));
        }
        break;
      case ViewAllStatus.trendingHits:
        for (var record in trendingHitsModel.records) {
          playerSongList.add(PlayerSongListModel(
              id: record.id,
              albumName: record.albumName.toString(),
              title: record.songName.toString(),
              imageUrl: generateSongImageUrl(record.albumName, record.albumId),
              musicDirectorName: record.musicDirectorName[0].toString(),
              duration: record.duration,
              premium: record.premiumStatus));
        }
        break;

      case ViewAllStatus.album:
        for (var record in albumSongListModel.records) {
          playerSongList.add(PlayerSongListModel(
              id: record.id,
              albumName: record.albumName.toString(),
              title: record.songName.toString(),
              imageUrl: generateSongImageUrl(record.albumName, record.albumId),
              musicDirectorName: record.musicDirectorName[0].toString(),
              duration: record.duration,
              premium: record.premiumStatus));
        }
        break;
      case ViewAllStatus.aura:
        for (var record in auraSongListModel.records) {
          playerSongList.add(PlayerSongListModel(
              id: record.auraSongs.songId,
              albumName: record.albumName.toString(),
              title: record.songName.toString(),
              imageUrl: generateSongImageUrl(record.albumName, record.albumId),
              musicDirectorName: record.musicDirectorName[0].toString(),
              duration: record.duration,
              premium: record.premiumStatus));
        }
        break;
      case ViewAllStatus.artist:
        for (var record in collectionViewAllModel.records) {
          playerSongList.add(PlayerSongListModel(
              id: record!.id,
              albumName: record.albumName.toString(),
              title: record.songName.toString(),
              imageUrl: generateSongImageUrl(record.albumName, record.albumId),
              musicDirectorName: record.musicDirectorName![0].toString(),
              duration: record.duration,
              premium: record.premiumStatus));
        }
        break;
      default:
        break;
    }
    notifyListeners();

    context.read<PlayerProvider>().goToPlayer(context, playerSongList, index);
  }

  addQueue(
    ViewAllStatus status,
    BuildContext context,
  ) {
    List<PlayerSongListModel> playerSongList = [];
    switch (status) {
      case ViewAllStatus.newRelease:
        for (var record in newReleaseModel.records) {
          playerSongList.add(PlayerSongListModel(
              id: record.id,
              albumName: record.albumName.toString(),
              title: record.songName.toString(),
              imageUrl: generateSongImageUrl(record.albumName, record.albumId),
              musicDirectorName: record.musicDirectorName[0].toString(),
              duration: record.duration,
              premium: record.premiumStatus));
        }
        break;
      case ViewAllStatus.recentlyPlayed:
        for (var record in recentlyPlayed.records) {
          playerSongList.add(PlayerSongListModel(
              id: record[0].id,
              albumName: record[0].albumName.toString(),
              title: record[0].songName.toString(),
              imageUrl:
                  generateSongImageUrl(record[0].albumName, record[0].albumId),
              musicDirectorName: record[0].musicDirectorName[0].toString(),
              duration: record[0].duration,
              premium: record[0].premiumStatus));
        }
        break;
      case ViewAllStatus.trendingHits:
        for (var record in trendingHitsModel.records) {
          playerSongList.add(PlayerSongListModel(
              id: record.id,
              albumName: record.albumName.toString(),
              title: record.songName.toString(),
              imageUrl: generateSongImageUrl(record.albumName, record.albumId),
              musicDirectorName: record.musicDirectorName[0].toString(),
              duration: record.duration,
              premium: record.premiumStatus));
        }
        break;

      case ViewAllStatus.album:
        for (var record in albumSongListModel.records) {
          playerSongList.add(PlayerSongListModel(
              id: record.id,
              albumName: record.albumName.toString(),
              title: record.songName.toString(),
              imageUrl: generateSongImageUrl(record.albumName, record.albumId),
              musicDirectorName: record.musicDirectorName[0].toString(),
              duration: record.duration,
              premium: record.premiumStatus));
        }
        break;
      case ViewAllStatus.aura:
        for (var record in auraSongListModel.records) {
          playerSongList.add(PlayerSongListModel(
              id: record.auraSongs.songId,
              albumName: record.albumName.toString(),
              title: record.songName.toString(),
              imageUrl: generateSongImageUrl(record.albumName, record.albumId),
              musicDirectorName: record.musicDirectorName[0].toString(),
              duration: record.duration,
              premium: record.premiumStatus));
        }
        break;
      case ViewAllStatus.artist:
        for (var record in collectionViewAllModel.records) {
          playerSongList.add(PlayerSongListModel(
              id: record!.id,
              albumName: record.albumName.toString(),
              title: record.songName.toString(),
              imageUrl: generateSongImageUrl(record.albumName, record.albumId),
              musicDirectorName: record.musicDirectorName![0].toString(),
              duration: record.duration,
              premium: record.premiumStatus));
        }
        break;
      default:
        break;
    }
    context
        .read<PlayerProvider>()
        .addSongToQueueSongList(playerSongList, context);
  }
}
