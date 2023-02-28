import 'package:flutter/material.dart';

import '../../../common_widgets/box/vertical_box.dart';
import '../../../core/constants/constant.dart';
import 'feature_row_widget.dart';

class PlanDescriptionWidget extends StatelessWidget {
  const PlanDescriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                ConstantText.features,
                style: fontWeight600(size: 14.0),
              ),
            ),
            Expanded(
              child: Center(
                  child: Text(
                ConstantText.free,
                style: fontWeight600(size: 14.0),
              )),
            ),
            Expanded(
              child: Text(
                ConstantText.premium,
                style: fontWeight600(size: 14.0),
              ),
            ),
          ],
        ),
        const VerticalBox(height: 12),
        const FeatureRowWidget(
            featureLabel: ConstantText.adFreeSong,
            freeIcon: Icons.close,
            premiumIcon: Icons.check),
        const VerticalBox(height: 16),
        const FeatureRowWidget(
            featureLabel: ConstantText.unlimitedStreaming,
            freeIcon: Icons.check,
            premiumIcon: Icons.check),
        const VerticalBox(height: 16),
        const FeatureRowWidget(
            featureLabel: ConstantText.access,
            freeIcon: Icons.close,
            premiumIcon: Icons.check),
      ],
    );
  }
}
