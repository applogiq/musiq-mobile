import 'package:flutter/material.dart';
// import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:musiq/src/features/library/provider/library_provider.dart';
import 'package:musiq/src/features/library/widgets/favourite/favourite_widgets.dart';
import 'package:musiq/src/features/payment/screen/subscription_screen.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/utils/url_generate.dart';
import '../../../auth/provider/login_provider.dart';
import '../../domain/models/favourite_model.dart';

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
        if (record[index].premiumStatus == "premium" &&
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
        padding: const EdgeInsets.only(left: 16, top: 16),
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomColorContainer(
                child: Image.network(
                  generateSongImageUrl(
                      record[index].albumName, record[index].albumId),
                  height: 60,
                  width: 60,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                      Images.noSong,
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover),
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
                          (record[index].premiumStatus == "premium" &&
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
            // Padding(
            //   padding: const EdgeInsets.only(right: 8),
            //   child: SizedBox(
            //       child: InkWell(
            //           onTap: () {
            //             showAnimatedDialog(
            //               // barrierColor: Colors.red,
            //               context: context,
            //               barrierDismissible: true,
            //               builder: (BuildContext context) {
            //                 return Center(
            //                     child: Container(
            //                   height: 250,
            //                   width: 200,
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(15),
            //                       color: const Color.fromRGBO(33, 33, 44, 1)),
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: const [
            //                       Text(
            //                         ConstantText.playNext,
            //                         style: TextStyle(
            //                           decoration: TextDecoration.none,
            //                           color: Colors.white,
            //                           fontSize: 18,
            //                         ),
            //                       ),
            //                       VerticalBox(height: 20),
            //                       Text(
            //                         ConstantText.addToQueue,
            //                         style: TextStyle(
            //                           decoration: TextDecoration.none,
            //                           color: Colors.white,
            //                           fontSize: 18,
            //                         ),
            //                       ),
            //                       VerticalBox(height: 20),
            //                       Text(
            //                         ConstantText.remove,
            //                         style: TextStyle(
            //                           decoration: TextDecoration.none,
            //                           color: Colors.white,
            //                           fontSize: 18,
            //                         ),
            //                       ),
            //                       VerticalBox(height: 20),
            //                       Text(
            //                         ConstantText.songInfo,
            //                         style: TextStyle(
            //                           decoration: TextDecoration.none,
            //                           color: Colors.white,
            //                           fontSize: 18,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ));

            //                 // ClassicGeneralDialogWidget(
            //                 //   titleText: 'Title',
            //                 //   contentText: 'content',
            //                 //   onPositiveClick: () {
            //                 //     Navigator.of(context).pop();
            //                 //   },
            //                 //   onNegativeClick: () {
            //                 //     Navigator.of(context).pop();
            //                 //   },
            //                 // );
            //               },
            //             );
            //           },
            //           child: const Icon(Icons.more_vert))),
            // ),
            // const Icon(
            //   Icons.more_vert,
            //   color: Colors.white,
            // )
            FavouritesPopUpMenuButton(
              record: record,
              index: index,
              mainContext: context,
            )
          ],
        ),
      ),
    );
  }
}
