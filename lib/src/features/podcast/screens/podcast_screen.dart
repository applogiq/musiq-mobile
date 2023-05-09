import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/core/constants/constant.dart';
import 'package:musiq/src/features/podcast/provider/podcast_provider.dart';
import 'package:provider/provider.dart';

class PodCastScreen extends StatefulWidget {
  const PodCastScreen({super.key});

  @override
  State<PodCastScreen> createState() => _PodCastScreenState();
}

class _PodCastScreenState extends State<PodCastScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PodcastProvider>(builder: (context, pro, objext) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const VerticalBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "Podcasts",
                style: fontWeight600(size: 25.5),
              ),
            ),
            const VerticalBox(height: 20),
            SizedBox(
              height: 25,
              // width: double.maxFinite,
              child: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                      pro.categoriesList.length,
                      (index) => Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16),
                            child: IntrinsicWidth(
                              child: InkWell(
                                onTap: () {
                                  pro.categoriesOnTapped(index);
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      pro.categoriesList[index].toString(),
                                    ),
                                    Container(
                                        height: 2,
                                        color: pro.selecteddindex == index
                                            ? Colors.red
                                            : Colors.transparent)
                                  ],
                                ),
                              ),
                            ),
                          )),
                ),
              ),
            ),
            Expanded(
                child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pro.categoriesList.length,
                    onPageChanged: (pages) {
                      pro.categoriesOnTapped(pages);
                    },
                    itemBuilder: (context, index) {
                      return pro.pages[pro.selecteddindex];
                    })),
          ],
        );
      }),
    );
  }
}
