import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/buttons/custom_button.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/routing/route_name.dart';
import '../../../../core/utils/navigation.dart';
import '../../../common/screen/no_song_screen.dart';
import '../../../search/provider/search_provider.dart';
import '../../../search/screens/search_screen.dart';

class NoPlaylistSong extends StatelessWidget {
  const NoPlaylistSong(
      {Key? key,
      required this.appBarTitle,
      required this.playListId,
      required this.popUpMenu})
      : super(key: key);
  final String appBarTitle;
  final Widget popUpMenu;
  final String playListId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 80),
        child: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back_ios_rounded)),
          title: Text(appBarTitle),
          actions: [popUpMenu],
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Spacer(),
              NoSongScreen(
                isFav: true,
                mainTitle: ConstantText.noSongHere,
                subTitle: ConstantText.noSongInPlayList,
              ),
              GestureDetector(
                  onTap: () {
                    context.read<SearchProvider>().resetState();
                    Navigation.navigateToScreen(
                      context,
                      RouteName.search,
                      args: SearchRequestModel(
                        searchStatus: SearchStatus.playlist,
                        playlistId: int.parse(playListId),
                      ),
                    );
                  },
                  child: const CustomButton(
                    label: ConstantText.addSong,
                    horizontalMargin: 105,
                  )),
              const Spacer(),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
