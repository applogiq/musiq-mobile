import 'package:flutter/material.dart';
import 'package:musiq/src/view/pages/home/components/play_button_widget.dart';

import 'horizontal_list_view.dart';

class TrendingHitsWidget extends StatelessWidget {
  const TrendingHitsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
      child: Column(
        children: [
          ListHeaderWidget(
            title: "Trending Hits",
            actionTitle: "View All",
          ),
          Container(
            padding: EdgeInsets.only(top: 16, right: 12, left: 12),
            height: 280,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage("assets/images/t1.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: PlayButtonWidget(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage("assets/images/t2.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: PlayButtonWidget(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage("assets/images/t3.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: PlayButtonWidget(),
                          ),
                        )),
                      ],
                    ),
                  ),
                  // Expanded(
                  //   flex: 7,
                  //   child: Container(
                  //     alignment: Alignment.center,
                  //     child: CustomColorContainer(
                  //       child: Stack(
                  //         alignment: Alignment.bottomRight,
                  //         children: [
                  //           Image.asset(
                  //             "assets/images/homepage/th1.png",
                  //             // height: 280,
                  //             fit: BoxFit.cover,
                  //           ),
                  //           PlayButtonWidget()
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Expanded(
                  //   flex: 4,
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: IntrinsicWidth(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         crossAxisAlignment: CrossAxisAlignment.stretch,
                  //         children: [
                  //           Expanded(
                  //             child: Align(
                  //               alignment: Alignment.center,
                  //               child: Stack(
                  //                 alignment: Alignment.bottomRight,
                  //                 children: [
                  //                   CustomColorContainer(
                  //                     child: Image.asset(
                  //                       "assets/images/t2.png",
                  //                       fit: BoxFit.fitHeight,
                  //                     ),
                  //                   ),
                  //                   PlayButtonWidget()
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             height: 8,
                  //           ),
                  //           Expanded(
                  //             child: Align(
                  //               alignment: Alignment.center,
                  //               child: Stack(
                  //                 alignment: Alignment.bottomRight,
                  //                 children: [
                  //                   CustomColorContainer(
                  //                     child: Image.asset(
                  //                       "assets/images/t3.png",
                  //                       fit: BoxFit.fitWidth,
                  //                     ),
                  //                   ),
                  //                   PlayButtonWidget()
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          )
          //Code ERROR
          // Container(
          //   padding: EdgeInsets.all(8),
          //   height: 240,
          //   child: Row(
          //     children: [
          //       IntrinsicHeight(
          //         child: Expanded(
          //             child: Stack(
          //           alignment: Alignment.bottomRight,
          //           children: [
          //             CustomColorContainer(
          //               child: Image.asset(
          //                 "assets/images/t1.png",
          //               ),
          //             ),
          // Container(
          //   margin: EdgeInsets.all(8),
          //   padding: EdgeInsets.all(12),
          //   decoration: BoxDecoration(
          //       color: CustomColor.playIconBg,
          //       shape: BoxShape.circle),
          //   child: Icon(
          //     Icons.play_arrow_rounded,
          //     size: 24,
          //     color: CustomColor.secondaryColor,
          //   ),
          // )
          //           ],
          //         )),
          //       ),
          //       Expanded(
          //           child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.stretch,
          //         children: [
          //           Expanded(
          //               child: Stack(
          //             alignment: Alignment.bottomRight,
          //             children: [
          //               CustomColorContainer(
          //                 child: Image.asset(
          //                   "assets/images/t2.png",
          //                   height: 112,
          //                   width: 141,
          //                   fit: BoxFit.contain,
          //                 ),
          //               ),
          //               Container(
          //                 margin: EdgeInsets.all(8),
          //                 padding: EdgeInsets.all(8),
          //                 decoration: BoxDecoration(
          //                     color: CustomColor.playIconBg,
          //                     shape: BoxShape.circle),
          //                 child: Icon(
          //                   Icons.play_arrow_rounded,
          //                   size: 24,
          //                   color: CustomColor.secondaryColor,
          //                 ),
          //               )
          //             ],
          //           )),
          //           SizedBox(
          //             height: 4,
          //           ),
          //           Expanded(
          //               child: Stack(
          //             alignment: Alignment.bottomRight,
          //             children: [
          //               CustomColorContainer(
          //                 child: Image.asset(
          //                   "assets/images/t2.png",
          //                   height: 112,
          //                   width: 141,
          //                   fit: BoxFit.contain,
          //                 ),
          //               ),
          //               Container(
          //                 margin: EdgeInsets.all(8),
          //                 padding: EdgeInsets.all(8),
          //                 decoration: BoxDecoration(
          //                     color: CustomColor.playIconBg,
          //                     shape: BoxShape.circle),
          //                 child: Icon(
          //                   Icons.play_arrow_rounded,
          //                   size: 24,
          //                   color: CustomColor.secondaryColor,
          //                 ),
          //               )
          //             ],
          //           )),
          //         ],
          //       ))
          //     ],
          //   ),
          // )

          //Code ERROR
        ],
      ),
    );
  }
}
