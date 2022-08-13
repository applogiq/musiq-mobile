import 'package:flutter/material.dart';
import 'package:musiq/src/constants/color.dart';
import 'package:musiq/src/widgets/custom_color_container.dart';

import '../pages/search_screen.dart';

class SearchAndNotifications extends StatelessWidget {
  const SearchAndNotifications({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: SearchTextWidget(
                isReadOnly: true,
                onTap: () {
                  print("DATA");
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchScreen()));
                },
                hint: "Search Music and Podcasts",
              ),
            ),
            SizedBox(
              width: 8,
            ),
            CustomColorContainer(
              bgColor: CustomColor.textfieldBg,
              left: 12,
              verticalPadding: 6,
              child: Center(
                child: Stack(
                  children: [
                    Icon(Icons.notifications),
                    Positioned(
                      right: 2,
                      child: new Container(
                        padding: EdgeInsets.all(4.5),
                        decoration: new BoxDecoration(
                          color: CustomColor.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}




class SearchTextWidget extends StatelessWidget {
  SearchTextWidget({
    Key? key,
    required this.hint,
    this.isReadOnly = false,
    required this.onTap,
  }) : super(key: key);
  final String hint;
  bool isReadOnly;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomColorContainer(
      left: 1,
      verticalPadding: 2,
      bgColor: CustomColor.textfieldBg,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(height: 40, width: double.maxFinite),
        child: TextField(
          onTap: onTap,
          readOnly: isReadOnly,
          onChanged: (val) {},
          cursorColor: Colors.white,
          decoration: InputDecoration(
              prefixIcon: Container(
                padding: EdgeInsets.all(12),
                child: Image.asset(
                  "assets/icons/search.png",
                  height: 16,
                  width: 16,
                  color: Colors.white,
                ),
              ),
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 14),
              hintText: hint),
        ),
      ),
    );
  }
}
