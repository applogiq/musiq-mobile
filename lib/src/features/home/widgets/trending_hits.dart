import 'package:flutter/material.dart';
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
            height: 240,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TrendingHitsHomeContainer(
                    trendingHitsModel: trendingHitsModel,
                    index: 0,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TrendingHitsHomeContainer(
                          trendingHitsModel: trendingHitsModel,
                          index: 1,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TrendingHitsHomeContainer(
                          trendingHitsModel: trendingHitsModel,
                          index: 2,
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
  }) : super(key: key);

  final TrendingHitsModel trendingHitsModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        child: Container(
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
              context.read<ViewAllProvider>().getViewAll(
                  ViewAllStatus.trendingHits,
                  context: context,
                  goToNextfunction: true,
                  index: index);
            },
            child: const Align(
              alignment: Alignment.bottomRight,
              child: PlayButtonWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
