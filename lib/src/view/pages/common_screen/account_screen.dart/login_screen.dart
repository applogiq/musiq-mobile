import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/on_boarding_screen.dart';
import 'package:musiq/src/view/pages/common_screen/offline_screen.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';

import '../../../../constants/color.dart';
import '../../../../constants/string.dart';
import '../../../../constants/style.dart';
import '../../../../helpers/utils/navigation.dart';
import '../../../../logic/controller/network_controller.dart';
import '../../../../logic/cubit/login_bloc.dart';
import '../../../../widgets/custom_text_field_with_error.dart';
import '../../../../widgets/empty_box.dart';
import 'components/background_image.dart';
import 'components/custom_loading_button.dart';
import 'components/logo_image.dart';

class LoginScreen extends StatefulWidget {
   LoginScreen({Key? key, this.passwordReset=false}) : super(key: key);
   bool passwordReset;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 late LoginBloc _loginScreenCubit;
 late bool passwordReset;
  @override
  void initState() {
    
    super.initState();
  
    this._loginScreenCubit=LoginBloc();
    passwordReset=widget.passwordReset;
  }
  @override
  void dispose() {
    
    super.dispose();
    _loginScreenCubit.dispose();
  
  }
  resetPasswordTimer()async{
Future.delayed(Duration(seconds: 2),(){
  setState(() {
    
 widget.passwordReset=false;
  });
});
  }
  @override
  Widget build(BuildContext context) {
          final NetworkController _networkController = Get.find<NetworkController>();

    return SafeArea(
      child: Obx((){
        return _networkController.connectionType.value==0?OfflineScreen():Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height-40,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                const Background(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: LogoWidget(
                          size: 60,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          ConstantText.welcomeBack,
                          style: fontWeight600(size: 24.0),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWithError(
                          onTap: () {},
                          label: ConstantText.email,
                          cubit: _loginScreenCubit,
                          stream: _loginScreenCubit.userNameStream,
                          isValidatorEnable: true,
                          onChange: (text) {
                            _loginScreenCubit.updateUserName(text);
                          }),
                      PasswordTextFieldWithError(
                          onTap: () async {
                            _loginScreenCubit.passwordTap();
                          },
                          isPassword: true,
                          label: ConstantText.password,
                          cubit: _loginScreenCubit,
                          stream: _loginScreenCubit.passwordStream,
                          isValidatorEnable: true,
                          onChange: (text) {
                            _loginScreenCubit.updatePassword(text);
                          }),
                      InkWell(onTap: () => Navigation.navigateToScreen(context, "forgotMain/"),child: ForgotPassword()),
                      widget.passwordReset?
                      FutureBuilder(
                        future: resetPasswordTimer()
                        ,builder:(context,snapshot){
                        return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: EdgeInsets.symmetric(vertical: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:  CustomColor.successStatusColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info,
                          color: snapshot.hasError ? Colors.red : Colors.green),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        ConstantText.passwordResetSuccess,
                        style: fontWeight400(
                          size: 14.0,
                          color: CustomColor.subTitle2,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                          onTap: () {
                           },
                          child: Icon(Icons.close))
                    ],
                  ),
                );
                      } ):EmptyBox(),
                       StatusContainer(cubit: _loginScreenCubit),
                      LoginButton(loginScreenCubit: _loginScreenCubit),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ConstantText.registerPrefix,
                              style: fontWeight500(size: 14.0),
                            ),
                            InkWell(
                              onTap: () {
                                Navigation.navigateReplaceToScreen(
                                    context, "register/");
                              },
                              child: Text(
                                " " + ConstantText.register,
                                style: fontWeight500(
                                    size: 14.0, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
      }) );
  }

  Future<int> getValue() async {
    return Future.value(5);
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
    required LoginBloc loginScreenCubit,
  })  : _loginScreenCubit = loginScreenCubit,
        super(key: key);

  final LoginBloc _loginScreenCubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: StreamBuilder(
          stream: _loginScreenCubit.validateForm,
          builder: (context, snapshot) {
            return InkWell(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_loginScreenCubit.isSuccess.value == true) {
                  } else {
                    print("snapshot.hasData");
                    print(_loginScreenCubit.isSuccess.value);

                    print(snapshot.data);
                    if (snapshot.data == null || snapshot.data == false) {
                      if (_loginScreenCubit.validator.value == true) {
                        var valid =
                            await _loginScreenCubit.checkEmptyValidation();

                        if (valid) {
                          if (snapshot.data == true) {
                            var res = await _loginScreenCubit.loginAPI(context);
                          }
                        } else {
                          print("INVALID");
                        }

                        print(_loginScreenCubit.userEmailController.value);
                      } else {
                        var valid =
                            await _loginScreenCubit.checkEmptyValidation();
                        print(valid);
                        print("leave");
                        _loginScreenCubit.validator.sink.add(true);

                        var valid1 =
                            await _loginScreenCubit.checkEmptyValidation();

                        if (valid1) {
                          if (snapshot.data == true) {
                            _loginScreenCubit.loginAPI(context);
                          }
                        }
                      }
                    } else if (snapshot.data == true) {
                      _loginScreenCubit.validator.sink.add(true);

                      var valid =
                          await _loginScreenCubit.checkEmptyValidation();

                      if (valid) {
                        if (snapshot.data == true) {
                          _loginScreenCubit.loginAPI(context);
                        }
                      }
                    }
                  }
// print("load");
                },
                child: StreamBuilder(
                    stream: _loginScreenCubit.loadingStream,
                    builder: (context, snapshot) {
                      return Stack(
                        children: [
                          Container(
                              margin: EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width,
                              height: 52,
                              decoration: BoxDecoration(
                                  color: _loginScreenCubit.isLoading.value ==
                                              false ||
                                          _loginScreenCubit.isSuccess.value ==
                                              true
                                      ? CustomColor.secondaryColor
                                      : CustomColor.buttonDisableColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  snapshot.data == true
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6.0, horizontal: 8),
                                          child: SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              )),
                                        )
                                      : Text(
                                          "Login",
                                          style: fontWeight500(
                                              color: _loginScreenCubit
                                                          .isSuccess.value ==
                                                      false
                                                  ? Colors.white
                                                  : CustomColor.subTitle2),
                                        ),
                                ],
                              ))),
                          _loginScreenCubit.isSuccess.value == true
                              ? Container(
                                  margin: EdgeInsets.all(0),
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.transparent,
                                  height: 52,
                                )
                              : EmptyBox()
                        ],
                      );
                    }));
          }),
    );
  }
}

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          ConstantText.forgotPassword,
          style: fontWeight500(color: CustomColor.subTitle2, size: 14.0),
        ),
      ),
    );
  }
}

class StatusContainer extends StatelessWidget {
  const StatusContainer({
    Key? key,required this.cubit,
  }) : super(key: key);
final cubit;
  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder(
        stream:cubit.errorStream,
        builder: (context, snapshot) {
          return snapshot.data == false
              ? EmptyBox()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: EdgeInsets.symmetric(vertical: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: snapshot.hasError
                        ? CustomColor.errorStatusColor
                        : CustomColor.successStatusColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info,
                          color: snapshot.hasError ? Colors.red : Colors.green),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        snapshot.hasError
                            ? snapshot.error.toString()
                            : "Login Success",
                        style: fontWeight400(
                          size: 14.0,
                          color: CustomColor.subTitle2,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            cubit.isInvalidCred.add(false);
                          },
                          child: Icon(Icons.close))
                    ],
                  ),
                );
        });
  }
}
