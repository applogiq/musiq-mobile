import 'package:flutter/material.dart';

import '../../../core/constants/constant.dart';

class FeatureRowWidget extends StatelessWidget {
  const FeatureRowWidget({
    Key? key,
    required this.featureLabel,
    required this.freeIcon,
    required this.premiumIcon,
  }) : super(key: key);
  final String featureLabel;
  final IconData freeIcon;
  final IconData premiumIcon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            featureLabel,
            style: fontWeight400(
              color: CustomColor.subTitle,
            ),
          ),
        ),
        Expanded(
          child: Align(
              alignment: Alignment.center,
              child: Center(child: Icon(freeIcon))),
        ),
        Expanded(
          child: Icon(premiumIcon),
        ),
      ],
    );
  }
}
