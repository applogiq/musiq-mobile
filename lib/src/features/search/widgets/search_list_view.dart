import 'package:flutter/material.dart';
import 'package:musiq/src/core/constants/constant.dart';
import 'package:musiq/src/core/utils/size_config.dart';
import 'package:musiq/src/features/common/packages/shimmer/shimmer.dart';
import 'package:musiq/src/features/search/widgets/playlist_song_seach_list_view.dart';
import 'package:musiq/src/features/search/widgets/search_artist_history.dart';
import 'package:musiq/src/features/search/widgets/search_artist_preference.dart';
import 'package:musiq/src/features/search/widgets/search_song_history.dart';
import 'package:musiq/src/features/search/widgets/song_search_list_view.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/enums.dart';
import '../provider/search_provider.dart';
import '../screens/search_screen.dart';
import 'no_record_widget.dart';

class SearchListView extends StatelessWidget {
  const SearchListView({
    Key? key,
    required this.searchRequestModel,
    required TextEditingController controller,
    required this.onChanged,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final SearchRequestModel searchRequestModel;
  final ValueSetter<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, pro, _) {
        return (pro.isRecentSearch &&
                searchRequestModel.searchStatus == SearchStatus.song)
            ? SongSearchHistoryBuilder(
                controller: _controller,
                onChanged: onChanged,
              )
            : (pro.isRecentSearch &&
                    searchRequestModel.searchStatus == SearchStatus.artist)
                ? ArtistSearchHistory(controller: _controller)
                : Builder(
                    builder: (context) {
                      if (searchRequestModel.searchStatus ==
                              SearchStatus.artist ||
                          searchRequestModel.searchStatus ==
                              SearchStatus.artistPreference) {
                        return pro.artistModel.message == "No records"
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                width: double.infinity,
                                child: const Center(child: NoRecordWidget()))
                            : pro.artistModel.records.isEmpty
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    width: double.infinity,
                                    child: Center(
                                        child: Text(
                                      "Search preferred Artist",
                                      style: fontWeight500(),
                                    )))
                                // : pro.isArtistSearch
                                //     ? loader(context)
                                : ArtistPrefereneSearchListView(
                                    searchRequestModel: searchRequestModel,
                                    pro: pro,
                                  );
                      } else {
                        return pro.searchSongModel.message == "No records"
                            ? const NoRecordWidget()
                            : searchRequestModel.searchStatus ==
                                    SearchStatus.playlist
                                ? PlaylistSearchSongTile(
                                    searchRequestModel: searchRequestModel,
                                    pro: pro,
                                  )
                                : pro.isSearch
                                    ? Column(
                                        children: [
                                          loader(context),
                                        ],
                                      )
                                    : SongSearchListView(
                                        provider: pro,
                                      );
                      }
                    },
                  );
      },
    );
  }
}

Shimmer loader(BuildContext context) {
  SizeConfig().init(context);

  return Shimmer.fromColors(
      baseColor: Colors.grey[600]!,
      highlightColor: const Color.fromRGBO(255, 255, 255, 0.1),
      child: ListView.builder(
        itemCount: 3,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18, top: 16),
                child: Container(
                  height: getProportionateScreenHeight(160),
                  width: getProportionateScreenWidth(160),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: CustomColor.activeIconBgColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(5, 31, 50, 0.08),
                        blurRadius: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 18, top: 16),
                child: Container(
                  height: getProportionateScreenHeight(160),
                  width: getProportionateScreenWidth(160),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: CustomColor.activeIconBgColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(5, 31, 50, 0.08),
                        blurRadius: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ));
}
