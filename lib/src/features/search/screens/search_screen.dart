import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/constants/style.dart';
import 'package:musiq/src/features/common/screen/no_song_screen.dart';
import 'package:musiq/src/features/home/provider/search_provider.dart';
import 'package:musiq/src/features/home/screens/artist_view_all/artist_view_all_screen.dart';
import 'package:musiq/src/features/player/domain/model/player_song_list_model.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:musiq/src/features/search/search_status.dart';
import 'package:musiq/src/utils/image_url_generate.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/list/horizontal_list_view.dart';
import '../../common/screen/offline_screen.dart';
import '../../home/domain/model/song_search_model.dart';
import '../../home/screens/sliver_app_bar/widgets/album_song_list.dart';
import '../../home/widgets/search_notifications.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.searchStatus}) : super(key: key);
  final SearchStatus searchStatus;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;
  Timer? _debounceTimer;
  void debouncing({required Function() fn, int waitForMs = 500}) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }

  @override
  void initState() {
    // context.read<SearchProvider>().init();
    _controller = TextEditingController();
    _controller.addListener(_onSearchChange);

    if (widget.searchStatus == SearchStatus.artist) {
      context.read<SearchProvider>().getArtistSearchHistory();
    } else {
      context.read<SearchProvider>().getSongSearchHistory();
    }
    super.initState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onSearchChange);
    _controller.dispose();
    super.dispose();

    // context.read<SearchProvider>().destroy();
  }

  void _onSearchChange() {
    debouncing(
      fn: () {
        // context.read<SearchProvider>().artistSearch(_controller.text);
        context
            .read<SearchProvider>()
            .getSearch(_controller.text, widget.searchStatus);
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
                            hint: widget.searchStatus == SearchStatus.artist
                                ? "Search Artist"
                                : "Search Music and Podcasts",
                            searchStatus: widget.searchStatus,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<SearchProvider>(builder: (context, pro, _) {
                    return (pro.isRecentSearch && pro.searchSongList.isNotEmpty)
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
                            if (widget.searchStatus == SearchStatus.artist) {
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
                                  : Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            pro.searchSongModel.records.length,
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                          onTap: () {
                                            context
                                                .read<SearchProvider>()
                                                .searchSongStore();
                                            Record rec = pro
                                                .searchSongModel.records[index];
                                            PlayerSongListModel
                                                playerSongListModel =
                                                PlayerSongListModel(
                                                    id: rec.id,
                                                    albumName: rec.albumName,
                                                    title: rec.songName,
                                                    imageUrl:
                                                        generateSongImageUrl(
                                                            rec.albumName,
                                                            rec.albumId),
                                                    musicDirectorName: rec
                                                        .musicDirectorName[0]);
                                            context
                                                .read<PlayerProvider>()
                                                .playSingleSong(context,
                                                    playerSongListModel);
                                          },
                                          child: SongListTile(
                                              albumName: pro.searchSongModel
                                                  .records[index].albumName,
                                              imageUrl: generateSongImageUrl(
                                                  pro.searchSongModel
                                                      .records[index].albumName,
                                                  pro.searchSongModel
                                                      .records[index].albumId),
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
