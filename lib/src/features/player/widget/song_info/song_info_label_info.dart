import 'package:flutter/material.dart';

import '../../../../core/constants/constant.dart';

class SongInfoLabelInfo extends StatelessWidget {
  const SongInfoLabelInfo({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style:
              fontWeight400(size: 16.0, color: Colors.white.withOpacity(0.6)),
        ),
        Text(
          value,
          style:
              fontWeight400(size: 16.0, color: Colors.white.withOpacity(0.6)),
        ),
      ],
    );
  }
}
