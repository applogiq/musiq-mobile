import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/common_widgets/container/custom_color_container.dart';
import 'package:musiq/src/constants/color.dart';
import 'package:musiq/src/constants/style.dart';
import 'package:musiq/src/features/common/screen/offline_screen.dart';
import 'package:musiq/src/features/home/provider/search_provider.dart';
import 'package:musiq/src/features/home/screens/artist_view_all/artist_view_all_screen.dart';
import 'package:musiq/src/features/library/screens/playlist/sliver_app_bar/widgets/album_song_list.dart';
import 'package:provider/provider.dart';

class AddPlayListSearchScreen extends StatelessWidget {
  const AddPlayListSearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    List recentSearch = [
      "Bad Guy",
      "Camilo cabello",
      "Workout guide",
      "The TRP show"
    ];
    //   SystemUiOverlay.bottom,
    // ]);
    return SafeArea(
      child: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? const OfflineScreen()
          : Scaffold(
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
                          child: PlayListSearchTextWidget(
                            onTap: () {
                              context.read<SearchProvider>().searchFieldTap();
                            },
                            hint: "Search Music and Podcasts",
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return const SongListTileView(
                                  imageUrl:
                                      "https://images.unsplash.com/photo-1499415479124-43c32433a620?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80",
                                  songName: "adada",
                                  musicDirectorName: "yuvan",
                                  songId: 2,
                                  albumName: "paiya");
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                  // Consumer<SearchProvider>(builder: (context, pro, _) {
                  //   return pro.isRecentSearch
                  //       ? Column(
                  //           children: [
                  //             const Padding(
                  //               padding: EdgeInsets.all(16.0),
                  //               child: ListHeaderWidget(
                  //                 title: "Recent Searches",
                  //                 actionTitle: "Clear",
                  //                 dataList: [],
                  //               ),
                  //             ),
                  //             ListView.builder(
                  //                 shrinkWrap: true,
                  //                 itemCount: recentSearch.length,
                  //                 itemBuilder: (context, index) {
                  //                   return Padding(
                  //                     padding: const EdgeInsets.all(16.0),
                  //                     child: Row(
                  //                       children: [
                  //                         const Icon(Icons.restore),
                  //                         Padding(
                  //                           padding: const EdgeInsets.symmetric(
                  //                               horizontal: 12.0),
                  //                           child: Text(
                  //                             recentSearch[index],
                  //                             style: fontWeight400(size: 14.0),
                  //                           ),
                  //                         )
                  //                       ],
                  //                     ),
                  //                   );
                  //                 })
                  //           ],
                  //         )
                  //       : pro.artistModel.message == "No records"
                  //           ? const Center(
                  //               child: Text("No Search"),
                  //             )
                  //           : Expanded(
                  //               child: ArtistGridView(
                  //                   artistModel: pro.artistModel));
                  // }),
                ],
              ),
            ),
    );
  }
}

class PlayListSearchTextWidget extends StatefulWidget {
  const PlayListSearchTextWidget({
    Key? key,
    required this.hint,
    this.isReadOnly = false,
    required this.onTap,
  }) : super(key: key);
  final String hint;
  final bool isReadOnly;

  final VoidCallback onTap;

  @override
  State<PlayListSearchTextWidget> createState() =>
      _PlayListSearchTextWidgetState();
}

class _PlayListSearchTextWidgetState extends State<PlayListSearchTextWidget> {
  late TextEditingController _controller;
  Timer? _debounceTimer;
  void debouncing({required Function() fn, int waitForMs = 500}) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.addListener(_onSearchChange);
    super.initState();
  }

  void _onSearchChange() {
    debouncing(
      fn: () {
        context.read<SearchProvider>().artistSearch(_controller.text);
      },
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onSearchChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomColorContainer(
      left: 1,
      verticalPadding: 2,
      bgColor: CustomColor.textfieldBg,
      child: ConstrainedBox(
        constraints:
            const BoxConstraints.expand(height: 40, width: double.maxFinite),
        child: TextField(
          controller: _controller,
          onTap: widget.onTap,
          readOnly: widget.isReadOnly,
          onChanged: (val) {},
          cursorColor: Colors.white,
          decoration: InputDecoration(
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  "assets/icons/search.png",
                  height: 16,
                  width: 16,
                  color: Colors.white,
                ),
              ),
              border: InputBorder.none,
              hintStyle: const TextStyle(fontSize: 14),
              hintText: widget.hint),
        ),
      ),
    );
  }
}

class SongListTileView extends StatelessWidget {
  const SongListTileView({
    super.key,
    required this.imageUrl,
    required this.songName,
    required this.musicDirectorName,
    required this.songId,
    required this.albumName,
  });
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
              IconButton(onPressed: () {}, icon: const Icon(Icons.add))
            ],
          ),
        ));
  }
}
