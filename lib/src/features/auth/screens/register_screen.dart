import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/constants/style.dart';
import 'package:musiq/src/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/app_bar.dart';
import '../../../common_widgets/buttons/custom_elevated_button.dart';
import '../../../common_widgets/text_field/custom_password_text_field.dart';
import '../../../common_widgets/text_field/custom_text_field.dart';
import '../../../constants/string.dart';
import '../../common/screen/offline_screen.dart';
import '../provider/register_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final registerProvider = Provider.of<RegisterProvider>(context);
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  Size(double.maxFinite, getProportionateScreenHeight(80)),
              child: Padding(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(8)),
                child: CustomAppBarWidget(
                  title: "New Account",
                ),
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(16),
                        horizontal: getProportionateScreenWidth(16)),
                    child: Column(
                      children: [
                        TextFieldWithError(
                            initialValue: "",
                            label: ConstantText.fullName,
                            onChange: (value) {
                              registerProvider.fullNameChanged(value);
                            },
                            onTap: () {},
                            errorMessage: registerProvider.fullNameError),
                        TextFieldWithError(
                            initialValue: "",
                            label: ConstantText.email,
                            onChange: (value) {
                              registerProvider.emailChanged(value);
                            },
                            onTap: () {
                              registerProvider.emailTapped();
                            },
                            errorMessage: registerProvider.emailError),
                        TextFieldWithError(
                            initialValue: "",
                            // isPassword: true,
                            label: ConstantText.userName,
                            onChange: (value) {
                              registerProvider.userNameChanged(value);
                            },
                            onTap: () {
                              registerProvider.emailError ==
                                      "Email already exists"
                                  ? null
                                  : registerProvider.userNameTapped();
                            },
                            errorMessage: registerProvider.userNameError),
                        PasswordTextFieldWithError(
                            isPassword: true,
                            label: ConstantText.password,
                            errorMessage: registerProvider.passwordError,
                            onChange: (value) {
                              registerProvider.passwordChanged(value);
                            },
                            onTap: () {
                              registerProvider.emailError ==
                                          "Email already exists" ||
                                      registerProvider.userNameError ==
                                          "Username already exists"
                                  ? null
                                  : registerProvider.passwordTapped();
                            }),
                        PasswordTextFieldWithError(
                            isPassword: true,
                            label: ConstantText.confirmPassword,
                            errorMessage: registerProvider.confirmPasswordError,
                            onChange: (value) {
                              registerProvider.confirmPasswordChanged(value);
                            },
                            onTap: () {
                              registerProvider.emailError ==
                                          "Email already exists" ||
                                      registerProvider.userNameError ==
                                          "Username already exists"
                                  ? null
                                  : registerProvider.confirmPasswordTapped();
                            }),
                        SizedBox(
                          height: getProportionateScreenHeight(15),
                        ),
                        registerProvider.isButtonEnable
                            ? Container(
                                height: getProportionateScreenHeight(52),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color.fromRGBO(96, 20, 20, 1)),
                                child: Center(
                                  child: Text(
                                    "Create account",
                                    style: fontWeight500(
                                        size: 16.0,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.75)),
                                  ),
                                ),
                              )
                            : CustomElevatedButton(
                                onTap: () {
                                  registerProvider.createAccount(context);
                                },
                                isValid: !registerProvider.isButtonLoading,
                                isLoading: registerProvider.isButtonLoading,
                                label: ConstantText.createAccount,
                                verticalMargin: 0.0,
                                horizontalMargin: 0.0,
                              )
                      ],
                    ),
                  ),
                ),
                Provider.of<InternetConnectionStatus>(context) ==
                        InternetConnectionStatus.disconnected
                    ? const OfflineScreen()
                    : const SizedBox.shrink()
              ],
            )));
  }
}
