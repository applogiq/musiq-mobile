import 'package:flutter/material.dart';
import 'package:musiq/src_main/constants/color.dart';
import 'package:musiq/src_main/route/route_name.dart';
import 'package:musiq/src_main/widgets/container/empty_box.dart';
import 'package:provider/provider.dart';
import '../../../src/widgets/custom_button.dart';
import '../../constants/string.dart';
import '../../constants/style.dart';
import '../../helpers/utils/navigation.dart';
import '../../provider/internet_connectivity_provider.dart';
import '../../provider/login_provider.dart';
import '../../widgets/buttons/text_with_button.dart';
import '../../widgets/image/auth_background.dart';
import '../../widgets/image/logo_image.dart';
import '../../widgets/text/forgot_password.dart';
import '../../widgets/text_field/custom_password_text_field.dart';
import '../../widgets/text_field/custom_text_field.dart';
import '../common_screen/offline_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<InternetConnectivityProvider>(context);
    return !networkProvider.isNetworkAvailable
        ? OfflineScreen()
        : Scaffold(
            body: SingleChildScrollView(
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
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
                        Consumer<LoginProvider>(
                            builder: (context, provider, _) {
                          return TextFieldWithError(
                              onTap: () {},
                              label: ConstantText.email,
                              errorMessage: provider.emailAddressErrorMessage,
                              isValidatorEnable: true,
                              onChange: (text) {
                                provider.emailAddressChanged(text);
                              });
                        }),
                        Consumer<LoginProvider>(
                            builder: (context, provider, _) {
                          return PasswordTextFieldWithError(
                              onTap: () async {
                                provider.passwordTap();
                              },
                              isPassword: true,
                              label: ConstantText.password,
                              errorMessage: provider.passwordErrorMessage,
                              isValidatorEnable: true,
                              onChange: (text) {
                                provider.passwordChanged(text);
                              });
                        }),
                        InkWell(
                            onTap: () => Navigation.navigateToScreen(
                                context, RouteName.forgotPassword),
                            child: ForgotPassword()),
                        StatusContainer(),
                        Consumer<LoginProvider>(
                            builder: (context, provider, _) {
                          return Stack(
                            children: [
                              InkWell(
                                onTap: provider.isLoginButtonEnable
                                    ? () {
                                        provider.login(context);
                                      }
                                    : () {},
                                child: CustomButton(
                                  isValid: provider.isLoginButtonEnable,
                                  isLoading: provider.isLoading,
                                  label: ConstantText.login,
                                  horizontalMargin: 0,
                                ),
                              ),
                              provider.isSuccess == true
                                  ? Container(
                                      margin: EdgeInsets.all(0),
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.transparent,
                                      height: 52,
                                    )
                                  : EmptyBox()
                            ],
                          );
                        }),
                        TextWithButton(
                            unClickableText: ConstantText.registerPrefix,
                            clickableText: ConstantText.register,
                            navigationString: RouteName.register)
                      ],
                    ),
                  )
                ])),
          ));
  }
}

class StatusContainer extends StatelessWidget {
  const StatusContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, provider, _) {
      return provider.isShowStatus == false
          ? EmptyBox()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: provider.isErrorStatus
                    ? CustomColor.errorStatusColor
                    : CustomColor.successStatusColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.info,
                      color:
                          provider.isErrorStatus ? Colors.red : Colors.green),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    provider.isErrorStatus
                        ? ConstantText.invalidEmailAndPassword
                        : "Login Success",
                    style: fontWeight400(
                      size: 14.0,
                      color: CustomColor.subTitle2,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        provider.closeDialog();
                      },
                      child: Icon(Icons.close))
                ],
              ),
            );
    });
  }
}
