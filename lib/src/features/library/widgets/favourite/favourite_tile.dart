import 'package:flutter/material.dart';
import 'package:musiq/src/features/payment/screen/subscription_screen.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/utils/url_generate.dart';
import '../../../auth/provider/login_provider.dart';
import '../../domain/models/favourite_model.dart';
import '../../provider/library_provider.dart';
import 'favourite_widgets.dart';

class FavouriteTile extends StatelessWidget {
  const FavouriteTile({
    Key? key,
    required this.record,
    required this.index,
  }) : super(key: key);

  final List<Record> record;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (record[index].premiumStatus != "premium" &&
            context.read<LoginProvider>().userModel!.records.premiumStatus ==
                "free") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SubscriptionsScreen()));
        } else {
          context.read<LibraryProvider>().playFavourite(context, index: index);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomColorContainer(
                child: Image.network(
                  generateSongImageUrl(
                      record[index].albumName, record[index].albumId),
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
                      Row(
                        children: [
                          Text(
                            record[index].songName,
                            style: fontWeight400(),
                          ),
                          (record[index].premiumStatus != "premium" &&
                                  context
                                          .read<LoginProvider>()
                                          .userModel!
                                          .records
                                          .premiumStatus ==
                                      "free")
                              ? Image.asset(
                                  Images.crownImage,
                                  height: 18,
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                      Text(
                        "${record[index].albumName} - ${record[index].musicDirectorName[0]}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: fontWeight400(
                            size: 12.0, color: CustomColor.subTitle),
                      ),
                    ],
                  ),
                )),
            FavouritesPopUpMenuButton(
              record: record,
              index: index,
            )
          ],
        ),
      ),
    );
  }
}
