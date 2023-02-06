import 'package:flutter/material.dart';

import '../../core/constants/color.dart';
import '../../core/constants/string.dart';
import '../../core/constants/style.dart';
import 'custom_color_container.dart';

class PasswordMessage extends StatelessWidget {
  const PasswordMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomColorContainer(
      left: 12.0,
      verticalPadding: 12.0,
      bgColor: CustomColor.textfieldBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info,
            color: CustomColor.subTitle2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                ConstantText.passwordToolTip,
                style: fontWeight400(
                  size: 12.0,
                  color: CustomColor.subTitle2,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          )
        ],
      ),
    );
  }
}
