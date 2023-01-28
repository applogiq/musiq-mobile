import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musiq/src/common_widgets/text_field/text_style.dart';
import 'package:musiq/src/features/auth/screens/decoration.dart';

class OTPField extends StatefulWidget {
  const OTPField({
    Key? key,
  }) : super(key: key);
  // final LoginProvider loginProvider;

  @override
  State<OTPField> createState() => _OTPFieldState();
}

class _OTPFieldState extends State<OTPField> {
  TextEditingController otpTextEditingController1 = TextEditingController();
  TextEditingController otpTextEditingController2 = TextEditingController();
  TextEditingController otpTextEditingController3 = TextEditingController();
  TextEditingController otpTextEditingController4 = TextEditingController();
  TextEditingController otpTextEditingController5 = TextEditingController();
  TextEditingController otpTextEditingController6 = TextEditingController();
  FocusNode? pin1FN;
  FocusNode? pin2FN;
  FocusNode? pin3FN;
  FocusNode? pin4FN;
  FocusNode? pin5FN;
  FocusNode? pin6FN;
  List focusNodes = [];
  List controller = [];
  @override
  void initState() {
    super.initState();
    pin1FN = FocusNode();
    pin2FN = FocusNode();
    pin3FN = FocusNode();
    pin4FN = FocusNode();
    pin5FN = FocusNode();
    pin6FN = FocusNode();
    focusNodes = [pin1FN, pin2FN, pin3FN, pin4FN, pin5FN, pin6FN];
    controller = [
      otpTextEditingController1,
      otpTextEditingController2,
      otpTextEditingController3,
      otpTextEditingController4,
      otpTextEditingController5,
      otpTextEditingController6
    ];
  }

  @override
  void dispose() {
    super.dispose();
    pin1FN?.dispose();
    pin2FN?.dispose();
    pin3FN?.dispose();
    pin4FN?.dispose();
    pin5FN?.dispose();
    pin6FN?.dispose();
    otpTextEditingController1.dispose();
    otpTextEditingController2.dispose();
    otpTextEditingController3.dispose();
    otpTextEditingController4.dispose();
    otpTextEditingController5.dispose();
    otpTextEditingController6.dispose();
  }

  focusChanged(value, int index) {
    if (focusNodes[index] == 0) {
      FocusScope.of(context).unfocus();
    } else if (focusNodes[index] == 5) {
      FocusScope.of(context).unfocus();
    } else if (value.length == 1) {
      FocusScope.of(context).nextFocus();
    } else if (value.length == 0) {
      FocusScope.of(context).previousFocus();
      // FocusScope.of(context).nearestScope.requestFocus();

    } else {}
    if (otpTextEditingController1.text.isNotEmpty &&
        otpTextEditingController2.text.isNotEmpty &&
        otpTextEditingController3.text.isNotEmpty &&
        otpTextEditingController4.text.isNotEmpty &&
        otpTextEditingController5.text.isNotEmpty &&
        otpTextEditingController6.text.isNotEmpty) {
      // widget.loginProvider.otpValid(true);
    } else {
      // widget.loginProvider.otpValid(false);

    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
          6,
          (index) => Form(
                child: SizedBox(
                  width: size.width / 7.4,
                  child: TextField(
                      controller: controller[index],
                      autofocus: true,
                      style: pinStyle,
                      keyboardType: TextInputType.number,
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      cursorColor: Colors.white,
                      cursorHeight: 30,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      onChanged: (value) {
                        focusChanged(value, index);
                      }),
                ),
              )),
    );
  }
}
