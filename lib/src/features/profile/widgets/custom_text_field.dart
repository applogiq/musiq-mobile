import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common_widgets/text_field/text_style.dart';
import '../../../constants/color.dart';
import '../../../utils/size_config.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.onChange,
      required this.keyboardType,
      required this.errorMessage,
      required this.fieldLabel,
      this.readOnly = false,
      required this.initialValue,
      required this.inputFormatter})
      : super(key: key);

  final String errorMessage;
  final String fieldLabel;
  final String initialValue;
  final List<TextInputFormatter> inputFormatter;
  final TextInputType keyboardType;
  final ValueSetter<String>? onChange;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldLabel,
          style: subTitleStyle().copyWith(
              fontSize: getProportionateScreenWidth(16),
              color: CustomColor.activeColor),
        ),
        SizedBox(
          height: getProportionateScreenHeight(7),
        ),
        SizedBox(
          height: 50,
          child: TextFormField(
            initialValue: initialValue,
            inputFormatters: inputFormatter,
            readOnly: readOnly,
            decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: CustomColor.textfieldBg)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: CustomColor.textfieldBg)),
                fillColor: CustomColor.textfieldBg,
                filled: true),
            cursorWidth: 1.2,
            cursorColor: CustomColor.activeColor,
            keyboardType: keyboardType,
            onChanged: onChange,
            style: readOnly
                ? headingTextStyle().copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: CustomColor.subTitle)
                : headingTextStyle()
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        errorMessage != ""
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 4.0),
                child: Text(
                  errorMessage,
                  style: subTitleStyle().copyWith(color: Colors.red),
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
