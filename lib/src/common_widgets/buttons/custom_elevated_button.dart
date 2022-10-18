import 'package:flutter/material.dart';
import 'package:musiq/src/constants/color.dart';
import 'package:musiq/src/constants/style.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {Key? key,
      required this.label,
      this.verticalMargin = 16,
      this.horizontalMargin = 16,
      this.isIcon = false,
      this.isValid = true,
      this.radius = 12,
      this.isLoading = false,
      required this.onTap})
      : super(key: key);
  final VoidCallback onTap;
  final String label;
  final double verticalMargin;
  final double horizontalMargin;
  final double radius;
  final bool isIcon;
  final bool isValid;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin, vertical: verticalMargin),
          width: MediaQuery.of(context).size.width,
          height: 52,
          decoration: BoxDecoration(
              color: isValid
                  ? CustomColor.secondaryColor
                  : CustomColor.secondaryColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(radius)),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isIcon ? const Icon(Icons.play_arrow_rounded) : const SizedBox(),
              isLoading
                  ? const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )),
                    )
                  : Text(
                      label,
                      style: fontWeight500(size: 16.0),
                    ),
            ],
          ))),
   
    );
  }
}
