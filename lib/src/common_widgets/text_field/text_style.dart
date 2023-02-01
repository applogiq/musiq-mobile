import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../../utils/size_config.dart';

TextStyle subTitleStyle() => TextStyle(
    fontWeight: FontWeight.w500,
    color: CustomColor.subTitle,
    fontSize: getProportionateScreenWidth(14));
TextStyle headingTextStyle() => TextStyle(
    fontWeight: FontWeight.w600, fontSize: getProportionateScreenWidth(36));
TextStyle pinStyle = TextStyle(
    fontSize: getProportionateScreenWidth(24), fontWeight: FontWeight.bold);
