import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/features/artist/domain/models/artist_model.dart';
import 'package:musiq/src/features/common/screen/offline_screen.dart';
import 'package:musiq/src/features/home/domain/model/artist_view_all_model.dart';
import 'package:musiq/src/features/home/provider/artist_view_all_provider.dart';
import 'package:musiq/src/routing/route_name.dart';
import 'package:musiq/src/utils/image_url_generate.dart';
import 'package:musiq/src/utils/navigation.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/app_bar.dart';
import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../constants/color.dart';
import '../../widgets/search_notifications.dart';

class ArtistViewAllScreen extends StatefulWidget {
  const ArtistViewAllScreen({
    super.key,
  });

  @override
  State<ArtistViewAllScreen> createState() => _ArtistViewAllScreenState();
}

class _ArtistViewAllScreenState extends State<ArtistViewAllScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var provider = Provider.of<ArtistViewAllProvider>(context, listen: false);
      provider.artistList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<InternetConnectionStatus>(context) ==
            InternetConnectionStatus.disconnected
        ? const OfflineScreen()
        : SafeArea(
            child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size(double.maxFinite, 50),
              child: CustomAppBarWidget(
                title: "Artists",
              ),
            ),
            body: Column(
              children: [
                const SearchSection(),
                Expanded(
                  child: Consumer<ArtistViewAllProvider>(
                      builder: (context, pro, _) {
                    return pro.isLoad
                        ? const LoaderScreen()
                        : ArtistGridView(artistModel: pro.artistModel);
                  }),
                )
              ],
            ),
          ));
  }
}

class ArtistGridView extends StatelessWidget {
  const ArtistGridView({super.key, required this.artistModel});
  final ArtistModel artistModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
      child: GridView.builder(
        semanticChildCount: 2,
        shrinkWrap: true,
        itemCount: artistModel.records.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.78),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigation.navigateToScreen(
                  context, RouteName.artistViewAllSongListScreen,
                  args: ArtistViewAllModel(
                      id: artistModel.records[index].id.toString(),
                      artistId: artistModel.records[index].artistId.toString(),
                      artistName:
                          artistModel.records[index].artistName.toString(),
                      isImage: artistModel.records[index].isImage));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (artistModel.records[index].isImage == false ||
                        artistModel.records[index].isImage == false)
                    ? Container(
                        height: 185,
                        width: 163.5,
                        decoration: BoxDecoration(
                            color: CustomColor.defaultCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: CustomColor.defaultCardBorder,
                                width: 2.0)),
                        child: Center(
                            child: Image.asset(
                          "assets/images/default/no_artist.png",
                          width: 113,
                          height: 118,
                        )),
                      )
                    : CustomColorContainer(
                        child: Image.network(
                        generateArtistImageUrl(
                            artistModel.records[index].artistId),
                        // "${APIConstants.baseUrl}${pro.artistModel.records[index].artistId}.png",
                        height: 185,
                        width: 163.5,
                        fit: BoxFit.cover,
                      )),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  artistModel.records[index].artistName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SearchSection extends StatelessWidget {
  const SearchSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SearchTextWidget(
        isReadOnly: true,
        onTap: () {
          Navigation.navigateToScreen(context, RouteName.search);
        },
        hint: "Search Artists",
      ),
    );
  }
}
