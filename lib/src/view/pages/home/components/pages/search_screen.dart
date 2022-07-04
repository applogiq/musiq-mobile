import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/view/pages/home/components/widget/horizontal_list_view.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';

import '../home_components/search_notifications.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  List recentSearch = [
    "Bad Guy",
    "Camilo cabello",
    "Workout guide",
    "The TRP show"
  ];
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    //   SystemUiOverlay.bottom,
    // ]);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.arrow_back_ios_rounded)),
                  ),
                  Expanded(
                    child: SearchTextWidget(
                      onTap: () {},
                      hint: "Search Music and Podcasts",
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListHeaderWidget(
                  title: "Recent Searches", actionTitle: "Clear",dataList: [],),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: recentSearch.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.restore),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            recentSearch[index],
                            style: fontWeight400(size: 14.0),
                          ),
                        )
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
