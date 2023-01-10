import 'package:flutter/material.dart';
import 'package:musiq/src/constants/images.dart';

import '../../../common_widgets/buttons/custom_button.dart';
import '../../../constants/color.dart';
import '../../../constants/string.dart';
import '../../../constants/style.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              Images.noInternet,
              width: 95,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 9),
              child: Text(
                ConstantText.noInternet,
                style: fontWeight600(),
              ),
            ),
            Text(
              ConstantText.pleaseTry,
              style: fontWeight400(color: CustomColor.subTitle2),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 44),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 140),
                child: CustomButton(
                  label: ConstantText.retry,
                  verticalMargin: 0.0,
                  horizontalMargin: 0.0,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
