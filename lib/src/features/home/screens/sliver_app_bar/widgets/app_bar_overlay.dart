import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/core/constants/constant.dart';
import 'package:musiq/src/core/constants/images.dart';
import 'package:provider/provider.dart';

import '../../../../../common_widgets/buttons/custom_button.dart';
import '../../../../payment/screen/subscription_screen.dart';
import '../../../provider/artist_view_all_provider.dart';

class AppBarOverlayContent extends StatelessWidget {
  const AppBarOverlayContent(
      {Key? key,
      required this.title,
      required this.count,
      required this.callback,
      required this.size,
      required this.addQueue,
      required this.popUpMenu,
      required this.isPremium,
      required this.istitleAndDescriptionVisible,
      this.podcastTitle = "",
      this.podcastSubtitle = "",
      this.podcastAuthor = ""})
      : super(key: key);

  final String title;
  final int count;
  final VoidCallback callback;
  final VoidCallback addQueue;
  final double size;
  final Widget popUpMenu;
  final bool isPremium;
  final bool istitleAndDescriptionVisible;
  final String podcastTitle;
  final String podcastSubtitle;
  final String podcastAuthor;

  @override
  Widget build(BuildContext context) {
    print(size);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            AnimatedOpacity(
              opacity: (size - 1.0).abs(),
              duration: const Duration(milliseconds: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            style: fontWeight600(
                                    size: size < 0.3
                                        ? 22.0
                                        : size > 0.48
                                            ? 0.0
                                            : 18.0)
                                .copyWith(overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        isPremium
                            ? size < 0.48
                                ? Image.asset(
                                    Images.crownImage,
                                    height: 24,
                                  )
                                : const SizedBox.shrink()
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                  istitleAndDescriptionVisible
                      ? const SizedBox.shrink()
                      : count <= 0
                          ? const SizedBox.shrink()
                          : size < 0.6
                              ? popUpMenu
                              : const SizedBox.shrink()
                ],
              ),
            ),
            istitleAndDescriptionVisible
                ? const VerticalBox(height: 5)
                : const SizedBox.shrink(),
            istitleAndDescriptionVisible
                ? Text(
                    podcastAuthor,
                    //  "",
                    style: fontWeight400(
                      size: size < 0.3
                          ? 14.0
                          : size > 0.48
                              ? 0.0
                              : 14.0,
                      color: const Color.fromRGBO(255, 255, 255, 0.8),
                    ),
                  )
                : const SizedBox.shrink(),
            istitleAndDescriptionVisible
                ? const VerticalBox(height: 12)
                : const SizedBox.shrink(),
            istitleAndDescriptionVisible
                ? Text(
                    podcastSubtitle,
                    //  "",
                    style: fontWeight400(
                        size: size < 0.3
                            ? 14.0
                            : size > 0.48
                                ? 0.0
                                : 14.0,
                        color: const Color.fromRGBO(255, 255, 255, 0.5)),
                    overflow: TextOverflow.visible,
                  )
                : const SizedBox.shrink(),
            istitleAndDescriptionVisible
                ? const SizedBox.shrink()
                : Text(
                    "$count Songs",
                    //  "",
                    style: fontWeight400(
                      size: size < 0.3
                          ? 14.0
                          : size > 0.48
                              ? 0.0
                              : 14.0,
                      color: CustomColor.subTitle2,
                    ),
                  ),
            count <= 0
                ? const SizedBox.shrink()
                : AnimatedOpacity(
                    opacity: (size - 1.0).abs(),
                    duration: const Duration(milliseconds: 100),
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: size > 0.5 ? 10 : 24, right: 16),
                      child: Consumer<ArtistViewAllProvider>(
                          builder: (context, pro, _) {
                        return isPremium
                            ? InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const SubscriptionsScreen()));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: size < 0.3
                                      ? 48
                                      : size < 0.4
                                          ? 48
                                          : size < 0.6
                                              ? 38
                                              : size < 0.65
                                                  ? 36
                                                  : 0,
                                  decoration: BoxDecoration(
                                    color: CustomColor.secondaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          Images.crownImage,
                                          height: 24,
                                        ),
                                        Text(
                                          ConstantText.getPremium,
                                          style: fontWeight500(size: 16.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  callback();
                                },
                                child: CustomButton(
                                    isIcon: true,
                                    label: "Play All ",
                                    horizontalMargin: 0.0,
                                    height: size < 0.3
                                        ? 48
                                        : size < 0.4
                                            ? 48
                                            : size < 0.6
                                                ? 34
                                                : size < 0.65
                                                    ? 32
                                                    : 0,
                                    verticalMargin: 0.0),
                              );
                      }),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
