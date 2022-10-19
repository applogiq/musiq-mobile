
import 'package:flutter/material.dart';
import 'package:musiq/src/constants/color.dart';


final otpTextFieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: BorderSide(color:Color.fromRGBO(255, 255, 255, 0.1)),
);

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
  border: otpTextFieldBorder,
  focusedBorder: otpTextFieldBorder.copyWith(borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),),
  enabledBorder: otpTextFieldBorder,
);
