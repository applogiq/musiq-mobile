
import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/helpers/utils/image_url_generate.dart';
import 'package:musiq/src/model/api_model/trending_hits_model.dart';

import '../../../../../helpers/constants/color.dart';
import '../../../../../helpers/constants/images.dart';
import '../../../../widgets/custom_color_container.dart';
import '../widget/horizontal_list_view.dart';

class NewRelease extends StatelessWidget {
  const NewRelease({
    Key? key,
    required this.new_release,
  }) : super(key: key);

  final TrendingHitsModel new_release;

  @override
  Widget build(BuildContext context) {
    return HorizonalListViewWidget(
        title: "New Releases",
        actionTitle: "",
        listWidget: Container(
      padding: EdgeInsets.only(top: 8),
      height:  200,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: new_release.records.length,
          itemBuilder: (context, index) => Row(
                children: [
                  index == 0
                      ? SizedBox(
                          width: 10,
                        )
                      : SizedBox(),
                  Container(
                     width: 125,
                    padding: EdgeInsets.fromLTRB(6, 8, 6, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomColorContainer(
                         
                          child: Image.network(
                            generateSongImageUrl(new_release.records[index].albumName, new_release.records[index].albumId),
                            height: 125,
                            width: 125,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          new_release.records[index].songName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                       Text(new_release.records[index].musicDirectorName[0],
                       overflow: TextOverflow.ellipsis,
                         
                                style: fontWeight400(size: 12.0,color: CustomColor.subTitle))
                      ],
                    ),
                  ),
                ],
              )),
    )
 );
  }
}
