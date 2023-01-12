import 'package:flutter/material.dart';
import 'package:musiq/src/constants/style.dart';

import '../../../common_widgets/list/horizontal_list_view.dart';
import '../../home/widgets/search_notifications.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    List recentSearch = [
      "Bad Guy",
      "Camilo cabello",
      "Workout guide",
      "The TRP show"
    ];
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
                        child: const Icon(Icons.arrow_back_ios_rounded)),
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
                title: "Recent Searches",
                actionTitle: "Clear",
                dataList: const [],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: recentSearch.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.restore),
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
