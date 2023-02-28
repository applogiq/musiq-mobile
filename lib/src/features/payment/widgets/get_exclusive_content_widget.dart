import 'package:flutter/material.dart';

import '../../../core/constants/constant.dart';

class GetExclusiveContentWidget extends StatelessWidget {
  const GetExclusiveContentWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        ConstantText.getExclusiveContent,
        style: fontWeight600(size: 26.0),
      ),
    );
  }
}

class GetExclusiveSubtitleWidget extends StatelessWidget {
  const GetExclusiveSubtitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        ConstantText.getExclusiveSubTopic,
        textAlign: TextAlign.center,
        style: fontWeight400(size: 12.0, color: CustomColor.subTitle),
      ),
    );
  }
}
