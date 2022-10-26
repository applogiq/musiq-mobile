import 'package:flutter/material.dart';
import 'package:musiq/src/constants/style.dart';
import 'package:musiq/src/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/app_bar.dart';
import '../../../../common_widgets/buttons/custom_elevated_button.dart';
import '../../../../common_widgets/text_field/custom_text_field.dart';
import '../../../../constants/string.dart';
import '../../provider/forgot_password_provider.dart';

class ForgotPasswordMainScreen extends StatefulWidget {
  const ForgotPasswordMainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPasswordMainScreen> createState() =>
      _ForgotPasswordMainScreenState();
}

class _ForgotPasswordMainScreenState extends State<ForgotPasswordMainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.maxFinite, 80),
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: CustomAppBarWidget(
                title: ConstantText.forgotPassword2,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ConstantText.forgotPasswordMain,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Consumer<ForgotPasswordProvider>(
                      builder: (context, provider, _) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: TextFieldWithError(
                          initialValue: "",
                          errorMessage: provider.emailAddressErrorMessage,
                          label: ConstantText.email,
                          onTap: () {},
                          isValidatorEnable: true,
                          onChange: (text) {
                            provider.emailChanged(text);
                          }),
                    );
                  }),
              SizedBox(height: getProportionateScreenHeight(50),),
                  Consumer<ForgotPasswordProvider>(
                      builder: (context, provider, _) {
                    return provider.isButtonEnable
                        ? InkWell(
                            onTap: () {
                              // provider.login();
                            },
                            child: Container(
                              height: getProportionateScreenHeight(52),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color.fromRGBO(96, 20, 20, 1)),
                              child: Center(
                                child: Text(
                                  "Continue",
                                  style: fontWeight500(
                                      size: 16.0,
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.75)),
                                ),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              provider.login(context);
                              print(provider.emailAddress);
                              provider.clearOTPError("");
                            },
                            child: Container(
                              height: getProportionateScreenHeight(52),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color.fromRGBO(254, 86, 49, 1)),
                              child: Center(
                                  child: provider.emailButtonLoad
                                      ? Text(
                                          "Continue",
                                          style: fontWeight500(
                                              size: 16.0,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.75)),
                                        )
                                      : CircularProgressIndicator(
                                          color: Colors.white,
                                        )),
                            ),
                          );
                  }),
                
                ],
              ),
            ),
          )),
    );
  }
}
