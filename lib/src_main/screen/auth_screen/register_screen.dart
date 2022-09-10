import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/string.dart';
import '../../provider/register_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/buttons/custom_elevated_button.dart';
import '../../widgets/text_field/custom_password_text_field.dart';
import '../../widgets/text_field/custom_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size(double.maxFinite, 80),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomAppBarWidget(
                  title: "New Account",
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFieldWithError(
                        label: ConstantText.fullName,
                        onChange: (value) {
                          registerProvider.fullNameChanged(value);
                        },
                        onTap: () {},
                        errorMessage: registerProvider.fullNameError),
                    TextFieldWithError(
                        label: ConstantText.email,
                        onChange: (value) {
                          registerProvider.emailChanged(value);
                        },
                        onTap: () {
                          registerProvider.emailTapped();
                        },
                        errorMessage: registerProvider.emailError),
                    TextFieldWithError(
                        label: ConstantText.userName,
                        onChange: (value) {
                          registerProvider.userNameChanged(value);
                        },
                        onTap: () {
                          registerProvider.userNameTapped();
                        },
                        errorMessage: registerProvider.userNameError),
                    PasswordTextFieldWithError(
                        label: ConstantText.password,
                        errorMessage: registerProvider.passwordError,
                        onChange: (value) {
                          registerProvider.passwordChanged(value);
                        },
                        onTap: () {
                          registerProvider.passwordTapped();
                        }),
                    PasswordTextFieldWithError(
                        label: ConstantText.confirmPassword,
                        errorMessage: registerProvider.confirmPasswordError,
                        onChange: (value) {
                          registerProvider.confirmPasswordChanged(value);
                        },
                        onTap: () {
                          registerProvider.confirmPasswordTapped();
                        })

                    // StreamBuilder(
                    //     stream: _regCubit.validateForm,
                    //     builder: (context, snapshot) {
                    //       return InkWell(
                    //           onTap: () async {
                    //             await _regCubit.createAccount();
                    //             if (snapshot.hasError == null) {
                    //               print("NULL");
                    //             } else if (snapshot.hasError == true) {
                    //               print("SOLVE ERROR");
                    //             } else if (snapshot.hasError == false) {
                    //               _regCubit.registerAPI(context);
                    //             } else {
                    //               print("OKAY");
                    //             }
                    //             // print("SSSSS");
                    //             // print(snapshot.hasError==null&&snapshot.hasError==false);
                    //             // print(snapshot.hasError==false);
                    //             // print(snapshot.hasError==null);
                    //             // print("DDDDDDDD");
                    //             // if(snapshot.hasError==false){
                    //             //   _regCubit.registerAPI(context);
                    //             // }
                    //           },
                    //           child: StreamBuilder(
                    //             stream: _regCubit.loadingStream,
                    //             builder: (context, snapshot) {
                    //               return _regCubit.isLoading.value == true
                    //                   ? CustomButton(
                    //                       label: ConstantText.createAccount,
                    //                       verticalMargin: 0.0,
                    //                       horizontalMargin: 0.0,
                    //                       isLoading: true,
                    //                     )
                    //                   : CustomButton(
                    //                       label: ConstantText.createAccount,
                    //                       verticalMargin: 0.0,
                    //                       horizontalMargin: 0.0,
                    //                     );
                    //             },
                    //           ));
                    //     })
                    ,
                    const SizedBox(
                      height: 15,
                    ),
                    CustomElevatedButton(
                      onTap: () {
                        registerProvider.createAccount();
                      },
                      label: ConstantText.createAccount,
                      verticalMargin: 0.0,
                      horizontalMargin: 0.0,
                    )
                  ],
                ),
              ),
            )));
  }
}
