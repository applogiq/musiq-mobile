import 'package:flutter/material.dart';
import 'package:musiq/src/constants/color.dart';
import 'package:musiq/src/constants/style.dart';
class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key, required this.label, this.verticalMargin = 16,this.horizontalMargin = 16, this.isIcon = false,this.isValid=true,this.radius=12,this.isLoading=false})
      : super(key: key);
  final String label;
  double verticalMargin;
  double horizontalMargin;
  double radius;
  bool isIcon;
  bool isValid;
  bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin,vertical: verticalMargin),
        width: MediaQuery.of(context).size.width,
        height: 52,
        decoration: BoxDecoration(
            color:isValid? CustomColor.secondaryColor:Color.fromRGBO(96, 20, 20, 1),
            borderRadius: BorderRadius.circular(radius)),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isIcon ? Icon(Icons.play_arrow_rounded) : SizedBox(),
          isLoading?Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6.0, horizontal: 8),
                                          child: SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              )),
                                        ):  Text(
              label,
              style: fontWeight500(size: 16.0),
            ),
          ],
        )));
  }
}
