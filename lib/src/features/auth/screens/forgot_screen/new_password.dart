import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/buttons/custom_button.dart';
import '../../../../common_widgets/text_field/custom_password_text_field.dart';
import '../../../../constants/string.dart';
import '../../../../constants/style.dart';
import '../../../common/screen/offline_screen.dart';
import '../../provider/new_password_provider.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({
    Key? key,
  }) : super(key: key);
  // final String email;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  // late ForgotpasswordCubit _forgotpasswordCubit;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _forgotpasswordCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    var passwordProvider = Provider.of<ForgotPasswordProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        context.read<ForgotPasswordProvider>().forgotPasswordOTPBack(context);
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.maxFinite, 80),
          child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: AppBar(
                toolbarHeight: 64,
                titleSpacing: 0.1,
                leading: InkWell(
                    onTap: () {
                      context
                          .read<ForgotPasswordProvider>()
                          .forgotPasswordOTPBack(context);
                      // Navigator.pop(context);
                      // newProvider.clearOTPvalue();
                      // newProvider.otpButtonEnable = true;
                    },
                    child: const Icon(Icons.arrow_back_ios_rounded)),
                title: const Text(
                  "Reset Password",
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ConstantText.resetPassswordTitle,
                    style: fontWeight400(size: 14.0),
                  ),
                  const VerticalBox(height: 24),
                  PasswordTextFieldWithError(
                      isPassword: true,
                      errorMessage: passwordProvider.newPasswordErrorMessage,
                      label: ConstantText.resetPassswordNew,
                      onTap: () {
                        passwordProvider.passwordTapped();
                      },
                      isValidatorEnable: true,
                      onChange: (value) {
                        passwordProvider.passwordChanged(value);
                      }),
                  const VerticalBox(height: 16),
                  PasswordTextFieldWithError(
                      isPassword: true,
                      errorMessage:
                          passwordProvider.confirmPasswordErrorMessage,
                      label: ConstantText.confirmPassword,
                      onTap: () {
                        passwordProvider.confirmPasswordTapped();
                      },
                      isValidatorEnable: true,
                      onChange: (value) {
                        passwordProvider.confirmPasswordChanged(value);
                      }),
                  Consumer<ForgotPasswordProvider>(
                    builder: (context, value, child) {
                      return GestureDetector(
                        onTap: () {
                          value.resetPassword(context);
                          // value.navigateToNext(context);
                          // value.emailVerfied(context);
                        },
                        child: CustomButton(
                          label: ConstantText.resetPasssword,
                          horizontalMargin: 0,
                          isValid: value.isResetButtonEnable,
                          isLoading: value.isResetLoading,
                        ),
                      );
                    },
                  )
                ],
              ),
            )),
            Provider.of<InternetConnectionStatus>(context) ==
                    InternetConnectionStatus.disconnected
                ? const OfflineScreen()
                : const SizedBox.shrink()
          ],
        ),
        // body: SingleChildScrollView(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: InkWell(
        //             onTap: () {
        //               // newProvider.updatePassword();
        //             },
        // child: Text(
        //   ConstantText.resetPassswordTitle,
        //   style: fontWeight400(size: 14.0),
        // ),
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(top: 24.0),
        // child: PasswordTextFieldWithError(
        //     isPassword: true,
        //     errorMessage: newProvider.newPasswordError,
        //     label: ConstantText.resetPassswordNew,
        //     onTap: () {
        //       newProvider.passwordTapped();
        //     },
        //     isValidatorEnable: true,
        //     onChange: (value) {
        //       newProvider.passwordChanged(value);
        //     }),
        //         ),
        //         PasswordTextFieldWithError(
        //             isPassword: true,
        //             errorMessage: newProvider.confirmPasswordError,
        //             label: ConstantText.confirmPassword,
        //             onTap: () {
        //               newProvider.confirmPasswordTapped();
        //             },
        //             isValidatorEnable: true,
        //             onChange: (value) {
        //               newProvider.confirmPasswordChanged(value);
        //             }),
        //         Padding(
        //             padding: const EdgeInsets.only(top: 60),
        //             child: newProvider.isResetButtonEnable
        //                 ? Container(
        //                     height: getProportionateScreenHeight(52),
        //                     width: double.maxFinite,
        //                     decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(12),
        //                         color: const Color.fromRGBO(96, 20, 20, 1)),
        //                     child: Center(
        //                       child: Text(
        //                         "Continue",
        //                         style: fontWeight500(
        //                             size: 16.0,
        //                             color: const Color.fromRGBO(
        //                                 255, 255, 255, 0.75)),
        //                       ),
        //                     ),
        //                   )
        //                 : InkWell(
        //                     onTap: () {
        //                       newProvider.updatePassword(context);
        //                       // provider.continueTapped(otpValue, context);
        //                     },
        //                     child: Container(
        //                       height: getProportionateScreenHeight(52),
        //                       width: double.maxFinite,
        //                       decoration: BoxDecoration(
        //                           borderRadius: BorderRadius.circular(12),
        //                           color: const Color.fromRGBO(254, 86, 49, 1)),
        //                       child: Center(
        //                           child: newProvider.emailButtonLoad
        //                               ? Text(
        //                                   "Continues",
        //                                   style: fontWeight500(
        //                                       size: 16.0,
        //                                       color: const Color.fromRGBO(
        //                                           255, 255, 255, 0.75)),
        //                                 )
        //                               : const CircularProgressIndicator(
        //                                   color: Colors.white,
        //                                 )),
        //                     ),
        //                   )

        //             //  CustomElevatedButton(
        //             //    onTap: () {
        //             //     newProvider.updatePassword(context);
        //             //    },
        //             //    label: ConstantText.resetPasssword,
        //             //    isLoading: false,
        //             //    verticalMargin: 0.0,
        //             //    horizontalMargin: 0.0,
        //             //  )

        //             )
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
