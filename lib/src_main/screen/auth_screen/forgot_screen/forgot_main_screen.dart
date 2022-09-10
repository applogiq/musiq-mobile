import 'package:flutter/material.dart';
import 'package:musiq/src/logic/cubit/forgot/cubit/forgotpassword_cubit.dart';
import 'package:musiq/src_main/provider/forgot_password_provider.dart';
import 'package:musiq/src_main/widgets/buttons/custom_elevated_button.dart';
import 'package:provider/provider.dart';

import '../../../constants/string.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/container/empty_box.dart';
import '../../../widgets/text_field/custom_text_field.dart';

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
                          errorMessage: provider.emailAddressErrorMessage,
                          label: ConstantText.email,
                          onTap: () {},
                          isValidatorEnable: true,
                          onChange: (text) {
                            provider.emailChanged(text);
                          }),
                    );
                  }),
                  Consumer<ForgotPasswordProvider>(
                      builder: (context, provider, _) {
                    return CustomElevatedButton(
                        horizontalMargin: 0,
                        isLoading: provider.isLoad,
                        label: ConstantText.continueButton,
                        onTap: () {
                          provider.sendOTP(context);
                        });
                  })
                  // StreamBuilder(
                  //     // stream: _forgotpasswordCubit.errorStream,
                  //     builder: (context, snap) {
                  //   print(snap);
                  //   return snap.hasError
                  //       ? Padding(
                  //           padding: const EdgeInsets.only(left: 8.0),
                  //           child: Text(
                  //             snap.error.toString(),
                  //             style: const TextStyle(color: Colors.red),
                  //             textAlign: TextAlign.left,
                  //           ),
                  //         )
                  //       : EmptyBox();
                  // }),

                  // Padding(
                  //     padding: const EdgeInsets.only(top: 100.0),
                  //     child: StreamBuilder(
                  //         stream: _forgotpasswordCubit.loadingStream,
                  //         builder: (context, snapshot) {
                  //           return snapshot.data == true
                  //               ? CustomButton(
                  //                   label: "label",
                  //                   verticalMargin: 0.0,
                  //                   horizontalMargin: 0.0,
                  //                   isLoading: true,
                  //                 )
                  //               : InkWell(
                  //                   onTap: () {
                  //                     _forgotpasswordCubit.sendOTP(context);
                  //                   },
                  //                   child: CustomButton(
                  //                     label: ConstantText.continueButton,
                  //                     verticalMargin: 0.0,
                  //                     horizontalMargin: 0.0,
                  //                   ));
                  //         })),
                ],
              ),
            ),
          )),
    );
  }
}
