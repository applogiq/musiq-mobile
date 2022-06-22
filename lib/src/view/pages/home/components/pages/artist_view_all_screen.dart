import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/view/pages/home/components/pages/view_all_screen.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';
import 'package:musiq/src/view/widgets/custom_app_bar.dart';
import 'package:musiq/src/view/widgets/custom_color_container.dart';

class ArtistListViewAll extends StatelessWidget {
  const ArtistListViewAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.maxFinite, 50),
        child: CustomAppBarWidget(
          title: "Artists",
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchTextWidget(
              onTap: () {},
              hint: "Search Artists",
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                semanticChildCount: 2,
                shrinkWrap: true,
                itemCount: Images().artistSearchList.length,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: InkWell(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => ViewAllScreen(
                      //         imageURL:
                      //             Images().artistSearchList[index].imageURL,
                      //         title: Images().artistSearchList[index].title)));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomColorContainer(
                          child: Image.asset(
                            Images().artistSearchList[index].imageURL,
                            height: 163,
                            width: 163.5,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          Images().artistSearchList[index].title,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.95),
              ),
            ),
          )
        ],
      ),
    );
  }
}
