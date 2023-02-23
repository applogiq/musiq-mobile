import 'package:flutter/material.dart';
import 'package:musiq/src/features/payment/screen/subscription_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constant.dart';
import '../../../core/enums/enums.dart';
import '../../../core/utils/url_generate.dart';
import '../../player/widget/player/player_widgets.dart';
import '../domain/model/trending_hits_model.dart';
import '../provider/view_all_provider.dart';
import '../screens/sliver_app_bar/view_all_screen.dart';

class TrendingHitsWidget extends StatelessWidget {
  const TrendingHitsWidget({
    Key? key,
    required this.trendingHitsModel,
  }) : super(key: key);
  final TrendingHitsModel trendingHitsModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(12.0, 12, 12.0, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                ConstantText.trendingHitsText,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  context.read<ViewAllProvider>().loaderEnable();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ViewAllScreen(
                            status: ViewAllStatus.trendingHits,
                          )));
                },
                child: Text(
                  "View All",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: CustomColor.secondaryColor),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 16, right: 12, left: 12),
            height: 260,
            width: double.maxFinite,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TrendingHitsHomeContainer(
                    height: 0,
                    width: 0,
                    trendingHitsModel: trendingHitsModel,
                    index: 0,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        TrendingHitsHomeContainer(
                          height: 120,
                          width: 120,
                          trendingHitsModel: trendingHitsModel,
                          index: 2,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TrendingHitsHomeContainer(
                          height: 120,
                          width: 120,
                          trendingHitsModel: trendingHitsModel,
                          index: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TrendingHitsHomeContainer extends StatelessWidget {
  const TrendingHitsHomeContainer({
    Key? key,
    required this.trendingHitsModel,
    required this.index,
    required this.height,
    required this.width,
  }) : super(key: key);

  final TrendingHitsModel trendingHitsModel;
  final int index;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(generateSongImageUrl(
                  trendingHitsModel.records[index].albumName,
                  trendingHitsModel.records[index].albumId)),
              fit: BoxFit.fill,
            ),
          ),
          child: InkWell(
            onTap: () {
              print(trendingHitsModel.records[index].premiumStatus);
              if (trendingHitsModel.records[index].premiumStatus == "free") {
                context.read<ViewAllProvider>().getViewAll(
                    ViewAllStatus.trendingHits,
                    context: context,
                    goToNextfunction: true,
                    index: index);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SubscriptionsScreen()));
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: InkWell(child: PlayButtonWidget()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
