import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../../constants/string.dart';
import '../../constants/style.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          ConstantText.forgotPassword,
          style: fontWeight500(color: CustomColor.subTitle2, size: 14.0),
        ),
      ),
    );
  }
}
