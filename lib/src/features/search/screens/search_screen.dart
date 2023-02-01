import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/list/horizontal_list_view.dart';
import '../../../constants/style.dart';
import '../../../utils/image_url_generate.dart';
import '../../common/screen/no_song_screen.dart';
import '../../common/screen/offline_screen.dart';
import '../../home/domain/model/song_search_model.dart';
import '../../home/provider/search_provider.dart';
import '../../home/screens/artist_view_all/artist_view_all_screen.dart';
import '../../home/screens/sliver_app_bar/widgets/album_song_list.dart';
import '../../home/widgets/search_notifications.dart';
import '../../player/domain/model/player_song_list_model.dart';
import '../../player/provider/player_provider.dart';
import '../search_status.dart';

class SearchRequestModel {
  SearchRequestModel({required this.searchStatus, this.playlistId});

  final int? playlistId;
  final SearchStatus searchStatus;
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.searchRequestModel})
      : super(key: key);

  final SearchRequestModel searchRequestModel;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onSearchChange);
    _controller.dispose();
    super.dispose();

    // context.read<SearchProvider>().destroy();
  }

  @override
  void initState() {
    // context.read<SearchProvider>().init();
    _controller = TextEditingController();
    _controller.addListener(_onSearchChange);

    if (widget.searchRequestModel.searchStatus == SearchStatus.artist) {
      context.read<SearchProvider>().getArtistSearchHistory();
    } else {
      context.read<SearchProvider>().getSongSearchHistory();
    }
    super.initState();
  }

  void debouncing({required Function() fn, int waitForMs = 500}) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }

  void _onSearchChange() {
    debouncing(
      fn: () {
        // context.read<SearchProvider>().artistSearch(_controller.text);
        context.read<SearchProvider>().getSearch(
            _controller.text,
            widget.searchRequestModel.searchStatus,
            widget.searchRequestModel.playlistId,
            context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? const OfflineScreen()
          : Scaffold(
              backgroundColor: const Color(0xFF16151C),
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Icon(Icons.arrow_back_ios_rounded)),
                        ),
                        Expanded(
                          child: SearchTextWidget(
                            textEditingController: _controller,
                            onTap: () {
                              // context.read<SearchProvider>().searchFieldTap();
                            },
                            hint: widget.searchRequestModel.searchStatus ==
                                    SearchStatus.artist
                                ? "Search Artist"
                                : "Search Music and Podcasts",
                            searchStatus:
                                widget.searchRequestModel.searchStatus,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<SearchProvider>(builder: (context, pro, _) {
                    return (pro.isRecentSearch &&
                            pro.searchSongList.isNotEmpty &&
                            widget.searchRequestModel.searchStatus !=
                                SearchStatus.playlist)
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ListHeaderWidget(
                                  title: "Recent Searches",
                                  actionTitle: "Clear",
                                  dataList: const [],
                                  callback: () {
                                    pro.clearSongHistoryList();
                                  },
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: context
                                      .read<SearchProvider>()
                                      .searchSongList
                                      .length,
                                  itemBuilder: (context, index) {
                                    List s = context
                                        .read<SearchProvider>()
                                        .searchSongList
                                        .reversed
                                        .toList();
                                    return InkWell(
                                      onTap: () {
                                        _controller.text = s[index];
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.restore),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: Text(
                                                s[index],
                                                style:
                                                    fontWeight400(size: 14.0),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                            ],
                          )
                        : Builder(builder: (context) {
                            if (widget.searchRequestModel.searchStatus ==
                                SearchStatus.artist) {
                              return pro.artistModel.message == "No records"
                                  ? const NoRecordWidget()
                                  : Expanded(
                                      child: ArtistGridView(
                                      artistModel: pro.artistModel,
                                      isFromSearch: true,
                                    ));
                            } else {
                              return pro.searchSongModel.message == "No records"
                                  ? const NoRecordWidget()
                                  : widget.searchRequestModel.searchStatus ==
                                          SearchStatus.playlist
                                      ? Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: pro
                                                .searchSongModel.records.length,
                                            itemBuilder: (context, index) =>
                                                InkWell(
                                              onTap: () {
                                                context
                                                    .read<SearchProvider>()
                                                    .searchSongStore();
                                                Record rec = pro.searchSongModel
                                                    .records[index];
                                                PlayerSongListModel
                                                    playerSongListModel =
                                                    PlayerSongListModel(
                                                        id: rec.id,
                                                        albumName:
                                                            rec.albumName,
                                                        title: rec.songName,
                                                        imageUrl:
                                                            generateSongImageUrl(
                                                                rec.albumName,
                                                                rec.albumId),
                                                        musicDirectorName:
                                                            rec.musicDirectorName[
                                                                0]);
                                                context
                                                    .read<PlayerProvider>()
                                                    .playSingleSong(context,
                                                        playerSongListModel);
                                              },
                                              child: SongPlayListTile(
                                                playlistId: widget
                                                    .searchRequestModel
                                                    .playlistId!,
                                                albumName: pro.searchSongModel
                                                    .records[index].albumName,
                                                imageUrl: generateSongImageUrl(
                                                    pro
                                                        .searchSongModel
                                                        .records[index]
                                                        .albumName,
                                                    pro
                                                        .searchSongModel
                                                        .records[index]
                                                        .albumId),
                                                musicDirectorName: pro
                                                    .searchSongModel
                                                    .records[index]
                                                    .musicDirectorName[0],
                                                songName: pro.searchSongModel
                                                    .records[index].songName,
                                                songId: pro.searchSongModel
                                                    .records[index].id,
                                                isAdded: pro.playlistSongId
                                                        .contains(pro
                                                            .searchSongModel
                                                            .records[index]
                                                            .id)
                                                    ? true
                                                    : false,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: pro
                                                .searchSongModel.records.length,
                                            itemBuilder: (context, index) =>
                                                InkWell(
                                              onTap: () {
                                                context
                                                    .read<SearchProvider>()
                                                    .searchSongStore();
                                                Record rec = pro.searchSongModel
                                                    .records[index];
                                                PlayerSongListModel
                                                    playerSongListModel =
                                                    PlayerSongListModel(
                                                        id: rec.id,
                                                        albumName:
                                                            rec.albumName,
                                                        title: rec.songName,
                                                        imageUrl:
                                                            generateSongImageUrl(
                                                                rec.albumName,
                                                                rec.albumId),
                                                        musicDirectorName:
                                                            rec.musicDirectorName[
                                                                0]);
                                                context
                                                    .read<PlayerProvider>()
                                                    .playSingleSong(context,
                                                        playerSongListModel);
                                              },
                                              child: SongListTile(
                                                  albumName: pro.searchSongModel
                                                      .records[index].albumName,
                                                  imageUrl:
                                                      generateSongImageUrl(
                                                          pro
                                                              .searchSongModel
                                                              .records[index]
                                                              .albumName,
                                                          pro
                                                              .searchSongModel
                                                              .records[index]
                                                              .albumId),
                                                  musicDirectorName: pro
                                                      .searchSongModel
                                                      .records[index]
                                                      .musicDirectorName[0],
                                                  songName: pro.searchSongModel
                                                      .records[index].songName,
                                                  songId: pro.searchSongModel
                                                      .records[index].id),
                                            ),
                                          ),
                                        );
                            }
                          });
                  }),
                ],
              ),
            ),
    );
  }
}

class NoRecordWidget extends StatelessWidget {
  const NoRecordWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: NoSongScreen(mainTitle: "No Records", subTitle: ""),
    );
  }
}
