import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/style.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_radio_button.dart';

class AudioQualitySettingScreen extends StatelessWidget {
  const AudioQualitySettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.maxFinite, 50),
        child: CustomAppBarWidget(
          title: "Audio Quality",
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Text(
              "Wifi",
              style: fontWeight500(),
            ),
            CustomRadio(),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                "Cellular Data",
                style: fontWeight500(),
              ),
            ),
            CustomRadio(),
          ],
        ),
        // padding: EdgeInsets.all(16),
        // child: Column(
        //   children: [CustomRadio()],
        // ),
      ),
    );
  }
}

class CustomRadioButton extends StatefulWidget {
  const CustomRadioButton({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Wifi",
            style: fontWeight500(),
          ),
        ),
        CustomRadio(),
        ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              return CustomRadioButtonTile(
                index: index,
                title: "Low",
                selectedIndex: index,
              );
            }),
        // CustomRadioButtonTile(
        //   title: "Medium",
        //   selectedIndex: 1,
        // ),
        // ListTile(
        //   onTap: () {
        //     selectedIndex = 1;
        //   },
        //   title: Text("Medium"),
        //   trailing: Icon(Icons.check),
        // ),
        // ListTile(
        //   onTap: () {
        //     selectedIndex = 2;
        //   },
        //   title: Text("High"),
        //   trailing: Icon(Icons.check),
        // ),
        // ListTile(
        //   onTap: () {
        //     selectedIndex = 3;
        //   },
        //   title: Text("Automatic"),
        //   trailing: Icon(Icons.check),
        // )
      ],
    );
  }
}

class CustomRadioButtonTile extends StatefulWidget {
  const CustomRadioButtonTile({
    Key? key,
    required this.selectedIndex,
    required this.title,
    required this.index,
  }) : super(key: key);
  final int selectedIndex;
  final int index;
  final String title;

  @override
  State<CustomRadioButtonTile> createState() => _CustomRadioButtonTileState();
}

class _CustomRadioButtonTileState extends State<CustomRadioButtonTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        print(widget.selectedIndex.toString());
        setState(() {
          widget.selectedIndex;
        });
      },
      title: Text(
        "Low",
        style: TextStyle(
            color: widget.selectedIndex == widget.index
                ? Colors.white
                : CustomColor.subTitle),
      ),
      trailing: Icon(Icons.check),
    );
  }
}
