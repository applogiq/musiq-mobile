import 'package:flutter/material.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  // late ForgotpasswordCubit _forgotpasswordCubit;
  @override
  void initState() {
    super.initState();

    // this._forgotpasswordCubit = ForgotpasswordCubit();
    // print(widget.email);
  }

  @override
  void dispose() {
    super.dispose();
    // _forgotpasswordCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size(double.maxFinite, 80),
        //   child: Padding(
        //     padding: EdgeInsets.only(top: 8.0),
        //     child: CustomAppBarWidget(
        //       title: ConstantText.resetPassswordAppbar,
        //     ),
        //   ),
        // ),
        // body: SingleChildScrollView(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Text(
        //             ConstantText.resetPassswordTitle,
        //             style: fontWeight400(size: 14.0),
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(top: 24.0),
        //           child: PasswordTextFieldWithError(
        //               isPassword: true,
        //               errorMessage: "",
        //               label: ConstantText.resetPassswordNew,
        //               onTap: () {
        //                 _forgotpasswordCubit.passwordTap();
        //               },
        //               isValidatorEnable: true,
        //               onChange: (text) {
        //                 _forgotpasswordCubit.updateUserNewPassword(text);
        //               }),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(top: 24.0),
        //           child: PasswordTextFieldWithError(
        //               isPassword: true,
        //               errorMessage: "",
        //               label: ConstantText.confirmPassword,
        //               onTap: () {
        //                 _forgotpasswordCubit.confirmPasswordTap();
        //               },
        //               isValidatorEnable: true,
        //               onChange: (text) {
        //                 _forgotpasswordCubit.updateUserConfirmPassword(text);
        //               }),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(top: 60),
        //           child: StreamBuilder(
        //               stream: _forgotpasswordCubit.validateForm,
        //               builder: (context, snapshot) {
        //                 return InkWell(
        //                     onTap: () {
        //                       if (snapshot.hasError) {
        //                         print("VALIDATE");
        //                       } else {
        //                         print("Valid");
        //                         _forgotpasswordCubit.changePassword(
        //                             widget.email,
        //                             _forgotpasswordCubit.passwordController.value,
        //                             context);
        //                       }
        //                     },
        //                     child: CustomElevatedButton(
        //                       onTap: () {},
        //                       label: ConstantText.resetPasssword,
        //                       isLoading: false,
        //                       verticalMargin: 0.0,
        //                       horizontalMargin: 0.0,
        //                     ));
        //               }),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
