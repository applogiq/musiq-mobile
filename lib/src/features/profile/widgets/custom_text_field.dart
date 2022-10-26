import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musiq/src/common_widgets/text_field/text_style.dart';
import 'package:musiq/src/constants/color.dart';
import 'package:musiq/src/utils/size_config.dart';



class CustomTextField extends StatelessWidget {
   CustomTextField(
      {Key? key,
      required this.onChange,
      required this.keyboardType,
      required this.errorMessage,
      required this.fieldLabel,
      this.readOnly = false,
      required this.initialValue,  required this.inputFormatter})
      : super(key: key);
  final ValueSetter<String>? onChange;
  final TextInputType keyboardType;
  final String errorMessage;
  final bool readOnly;
  final String fieldLabel;
  final String initialValue;
  final List<TextInputFormatter> inputFormatter;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldLabel,
          style: subTitleStyle().copyWith(fontSize: getProportionateScreenWidth(16),color: CustomColor.activeColor),
        ),
        SizedBox(
          height: getProportionateScreenHeight(7),
        ),
        SizedBox(
          height: 50,
          child: TextFormField(
            initialValue: initialValue,
            inputFormatters:inputFormatter,
            readOnly: readOnly,
            decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: CustomColor.textfieldBg)),
                
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:  BorderSide(color:CustomColor.textfieldBg)),
                fillColor: CustomColor.textfieldBg,
                filled: true),
            cursorWidth: 1.2,
            cursorColor: CustomColor.activeColor,
            keyboardType: keyboardType,
            onChanged: onChange,
            style: readOnly
                ? headingTextStyle()
                    .copyWith(fontSize: 18,fontWeight: FontWeight.w500, color: CustomColor.subTitle)
                : headingTextStyle().copyWith(
                    fontSize: 18,fontWeight: FontWeight.w500
                  ),
          ),
        ),
        errorMessage!=""
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
