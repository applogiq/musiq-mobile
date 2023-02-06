import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/features/artist/provider/artist_provider.dart';
import 'package:musiq/src/features/artist/screens/artist_preference_screen/artist_preference_body.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../common_widgets/image/no_artist.dart';
import '../../../core/constants/constant.dart';
import '../../../core/enums/search_status.dart';
import '../../../core/utils/url_generate.dart';
import '../../common/screen/offline_screen.dart';
import '../../home/domain/model/song_search_model.dart';
import '../../home/screens/artist_view_all/artist_view_all_screen.dart';
import '../../home/screens/sliver_app_bar/widgets/song_play_list_tile.dart';
import '../../home/widgets/search_notifications.dart';
import '../../player/domain/model/player_song_list_model.dart';
import '../../player/provider/player_provider.dart';
import '../provider/search_provider.dart';
import '../widgets/no_record_widget.dart';
import '../widgets/search_artist_history.dart';
import '../widgets/search_artist_preference.dart';
import '../widgets/search_song_history.dart';

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
      // context.read<SearchProvider>().getArtistSearchHistory();
    } else if (widget.searchRequestModel.searchStatus ==
        SearchStatus.artistPreference) {
      // context.read<SearchProvider>().getUserFollowedList();
      context.read<SearchProvider>().searchArtistPreference();
    } else {
      // context.read<SearchProvider>().getSongSearchHistory();
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
      child:
          Provider.of<InternetConnectionStatus>(context) ==
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
                                  child:
                                      const Icon(Icons.arrow_back_ios_rounded)),
                            ),
                            Expanded(
                              child: SearchTextWidget(
                                textEditingController: _controller,
                                onTap: () {
                                  // context.read<SearchProvider>().searchFieldTap();
                                },
                                hint: (widget.searchRequestModel.searchStatus ==
                                            SearchStatus.artist ||
                                        widget.searchRequestModel
                                                .searchStatus ==
                                            SearchStatus.artistPreference)
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
                                widget.searchRequestModel.searchStatus ==
                                    SearchStatus.song)
                            ? SongSearchHistoryBuilder(controller: _controller)
                            : (pro.isRecentSearch &&
                                    widget.searchRequestModel.searchStatus ==
                                        SearchStatus.artist)
                                ? ArtistSearchHistory(controller: _controller)
                                : Builder(builder: (context) {
                                    if (widget.searchRequestModel
                                                .searchStatus ==
                                            SearchStatus.artist ||
                                        widget.searchRequestModel
                                                .searchStatus ==
                                            SearchStatus.artistPreference) {
                                      return pro.artistModel.message ==
                                              "No records"
                                          ? const NoRecordWidget()
                                          : Expanded(
                                              child:
                                                  widget.searchRequestModel
                                                              .searchStatus ==
                                                          SearchStatus
                                                              .artistPreference
                                                      ? ListView.builder(
                                                          itemCount: pro
                                                              .artistModel
                                                              .records
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              child: Row(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: pro.artistModel.records[index].isImage ==
                                                                            false
                                                                        ? const CustomColorContainer(
                                                                            child:
                                                                                NoArtist(
                                                                              height: 80,
                                                                              width: 80,
                                                                            ),
                                                                          )
                                                                        : CustomColorContainer(
                                                                            child:
                                                                                ArtistImagesWidget(
                                                                              url: generateArtistImageUrl(pro.artistModel.records[index].artistId),
                                                                            ),
                                                                          ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 7,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .fromLTRB(
                                                                          8.0,
                                                                          8.0,
                                                                          8.0,
                                                                          8.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            pro.artistModel.records[index].artistName,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            maxLines:
                                                                                1,
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              const Icon(Icons.people),
                                                                              const SizedBox(
                                                                                width: 8,
                                                                              ),
                                                                              Text(
                                                                                "0",
                                                                                style: TextStyle(color: CustomColor.subTitle, fontWeight: FontWeight.w400, fontSize: 14),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Consumer<
                                                                          ArtistPreferenceProvider>(
                                                                      builder:
                                                                          (context,
                                                                              pro,
                                                                              _) {
                                                                    return Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal: pro.userFollowedArtist.contains(pro.artistModel!.records[index].artistId)
                                                                                ? 12
                                                                                : 16,
                                                                            vertical:
                                                                                4),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            context.read<ArtistPreferenceProvider>().checkFollow(
                                                                                pro.artistModel!.records[index],
                                                                                index,
                                                                                context);
                                                                            // provider.checkFollow(
                                                                            //     provider.artistModel!.records[index], index);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: context.read<ArtistPreferenceProvider>().userFollowedArtist.contains(context.read<ArtistPreferenceProvider>().artistModel!.records[index].artistId) ? 12 : 10, vertical: 4),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(6),
                                                                              color: context.read<ArtistPreferenceProvider>().userFollowedArtist.contains(context.read<ArtistPreferenceProvider>().artistModel!.records[index].artistId) ? CustomColor.followingColor : CustomColor.secondaryColor,
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                context.read<ArtistPreferenceProvider>().userFollowedArtist.contains(context.read<ArtistPreferenceProvider>().artistModel!.records[index].artistId) ? "Unfollow" : "Follow",
                                                                                style: fontWeight400(),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      : ArtistGridView(
                                                          artistModel:
                                                              pro.artistModel,
                                                          isFromSearch: true,
                                                        ));
                                    } else {
                                      return pro.searchSongModel.message ==
                                              "No records"
                                          ? const NoRecordWidget()
                                          : widget.searchRequestModel
                                                      .searchStatus ==
                                                  SearchStatus.playlist
                                              ? Expanded(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: pro
                                                        .searchSongModel
                                                        .records
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            InkWell(
                                                      onTap: () {
                                                        context
                                                            .read<
                                                                SearchProvider>()
                                                            .searchSongStore();
                                                        Record rec = pro
                                                            .searchSongModel
                                                            .records[index];
                                                        PlayerSongListModel
                                                            playerSongListModel =
                                                            PlayerSongListModel(
                                                                id: rec.id,
                                                                albumName: rec
                                                                    .albumName,
                                                                title: rec
                                                                    .songName,
                                                                imageUrl: generateSongImageUrl(
                                                                    rec
                                                                        .albumName,
                                                                    rec
                                                                        .albumId),
                                                                musicDirectorName:
                                                                    rec.musicDirectorName[
                                                                        0],
                                                                duration: rec
                                                                    .duration);
                                                        context
                                                            .read<
                                                                PlayerProvider>()
                                                            .playSingleSong(
                                                                context,
                                                                playerSongListModel);
                                                      },
                                                      child: SongPlayListTile(
                                                        playlistId: widget
                                                            .searchRequestModel
                                                            .playlistId!,
                                                        albumName: pro
                                                            .searchSongModel
                                                            .records[index]
                                                            .albumName,
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
                                                        songName: pro
                                                            .searchSongModel
                                                            .records[index]
                                                            .songName,
                                                        songId: pro
                                                            .searchSongModel
                                                            .records[index]
                                                            .id,
                                                        isAdded: pro
                                                                .playlistSongId
                                                                .contains(pro
                                                                    .searchSongModel
                                                                    .records[
                                                                        index]
                                                                    .id)
                                                            ? true
                                                            : false,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SearchArtistPreference();
                                    }
                                  });
                      }),
                    ],
                  ),
                ),
    );
  }
}
