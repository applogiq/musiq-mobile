import 'package:flutter/material.dart';
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
                            ? const NoRecordWidget()
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
