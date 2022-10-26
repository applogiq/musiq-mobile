import 'package:flutter/material.dart';
import 'package:musiq/src/utils/size_config.dart';



class VerticalBox extends StatelessWidget {
  const VerticalBox({
    Key? key, required this.height,
    
  }) : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(height),
    );
  }
}
