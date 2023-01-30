import 'package:flutter/material.dart';
import 'package:musiq/src/features/home/domain/model/album_model.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../constants/color.dart';
import '../../../constants/style.dart';
import '../../../utils/image_url_generate.dart';
import '../provider/view_all_provider.dart';
import '../screens/sliver_app_bar/view_all_screen.dart';
import '../view_all_status.dart';

class TopAlbum extends StatelessWidget {
  const TopAlbum({super.key, required this.album});
  final Album album;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: const [
              Text(
                "Top Albums",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Spacer(),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8),
          height: 200,
          child: ListView.builder(
              // reverse: true,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: album.records.length,
              itemBuilder: (context, index) => Row(
                    children: [
                      index == 0
                          ? const SizedBox(
                              width: 10,
                            )
                          : const SizedBox(),
                      Container(
                        padding: const EdgeInsets.fromLTRB(6, 8, 6, 0),
                        width: 135,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                context.read<ViewAllProvider>().loaderEnable();

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ViewAllScreen(
                                          status: ViewAllStatus.album,
                                          id: album.records[index].id,
                                        )));
                              },
                              child: CustomColorContainer(
                                child: Image.network(
                                  generateSongImageUrl(
                                      album.records[index].albumName,
                                      album.records[index].albumId),
                                  height: 125,
                                  width: 135,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              album.records[index].albumName.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                                album.records[index].musicDirectorName[0]
                                    .toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: fontWeight400(
                                    size: 12.0, color: CustomColor.subTitle))
                          ],
                        ),
                      ),
                    ],
                  )),
        ),
      ],
    );
  }
}
