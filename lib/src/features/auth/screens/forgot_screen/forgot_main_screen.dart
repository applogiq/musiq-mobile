import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/common_widgets/buttons/custom_button.dart';
import 'package:musiq/src/features/common/screen/offline_screen.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/app_bar.dart';
import '../../../../common_widgets/text_field/custom_text_field.dart';
import '../../../../constants/string.dart';
import '../../provider/new_password_provider.dart';

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
      child: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? const OfflineScreen()
          : Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size(double.maxFinite, 80),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
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
                      const VerticalBox(height: 60),
                      Consumer<ForgotPasswordProvider>(
                        builder: (context, value, child) {
                          return GestureDetector(
                            onTap: () {
                              // value.navigateToNext(context);
                              value.emailVerfied(context);
                            },
                            child: CustomButton(
                              label: ConstantText.continueButton,
                              horizontalMargin: 0,
                              isValid: value.isEmailButtonEnable,
                              isLoading: value.isEmailLoading,
                            ),
                          );
                        },
                      )
                      // Consumer<ForgotPasswordProvider>(
                      //     builder: (context, provider, _) {
                      //   return provider.isButtonEnable
                      //       ? InkWell(
                      //           onTap: () {
                      //             // provider.login();
                      //           },
                      //           child: Container(
                      //             height: getProportionateScreenHeight(52),
                      //             width: double.maxFinite,
                      //             decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(12),
                      //                 color: const Color.fromRGBO(96, 20, 20, 1)),
                      //             child: Center(
                      //               child: Text(
                      //                 "Continue",
                      //                 style: fontWeight500(
                      //                     size: 16.0,
                      //                     color: const Color.fromRGBO(
                      //                         255, 255, 255, 0.75)),
                      //               ),
                      //             ),
                      //           ),
                      //         )
                      //       : InkWell(
                      //           onTap: () {
                      //             provider.login(context);

                      //             provider.clearOTPError("");
                      //           },
                      //           child: Container(
                      //             height: getProportionateScreenHeight(52),
                      //             width: double.maxFinite,
                      //             decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(12),
                      //                 color: const Color.fromRGBO(254, 86, 49, 1)),
                      //             child: Center(
                      //                 child: provider.emailButtonLoad
                      //                     ? Text(
                      //                         "Continue",
                      //                         style: fontWeight500(
                      //                             size: 16.0,
                      //                             color: const Color.fromRGBO(
                      //                                 255, 255, 255, 0.75)),
                      //                       )
                      //                     : const CircularProgressIndicator(
                      //                         color: Colors.white,
                      //                       )),
                      //           ),
                      //         );
                      // }),
                    ],
                  ),
                ),
              )),
    );
  }
}
