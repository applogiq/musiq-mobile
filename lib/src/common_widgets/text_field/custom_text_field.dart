import 'package:flutter/material.dart';
import 'package:musiq/src/utils/size_config.dart';

import '../../constants/color.dart';
import '../../constants/style.dart';
import '../container/custom_color_container.dart';

class TextFieldWithError extends StatelessWidget {
  const TextFieldWithError(
      {Key? key,
      this.isPassword = false,
      this.isValidatorEnable = false,
      required this.label,
      this.onChange,
      required this.onTap,
      required this.errorMessage,
      required this.initialValue})
      : super(key: key);
  final bool isValidatorEnable;
  final bool isPassword;
  final String initialValue;
  final String label;
  final String errorMessage;
  final ValueSetter<String>? onChange;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            label,
            style: fontWeight500(size: getProportionateScreenHeight(14)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: CustomColorContainer(
            left: 16,
            right: getProportionateScreenWidth(24),
            verticalPadding: 0,
            bgColor: CustomColor.textfieldBg,
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(
                  height: 46, width: double.maxFinite),
              child: TextFormField(
                initialValue: initialValue,
                onTap: onTap,
                cursorColor: Colors.white,
                onChanged: onChange,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle:
                      TextStyle(fontSize: getProportionateScreenHeight(14)),
                ),
              ),
            ),
          ),
        ),
        Builder(builder: (context) {
          if (errorMessage == "") {
            return const SizedBox.shrink();
          } else {
            return Padding(
              padding: EdgeInsets.only(left: getProportionateScreenWidth(8)),
              child: Text(
                errorMessage.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
        })
      ],
    );
  }
}
