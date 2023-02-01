import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/buttons/custom_button.dart';
import '../../../common_widgets/buttons/text_with_button.dart';
import '../../../common_widgets/container/empty_box.dart';
import '../../../common_widgets/image/auth_background.dart';
import '../../../common_widgets/image/logo_image.dart';
import '../../../common_widgets/text/forgot_password.dart';
import '../../../common_widgets/text_field/custom_password_text_field.dart';
import '../../../common_widgets/text_field/custom_text_field.dart';
import '../../../constants/color.dart';
import '../../../constants/string.dart';
import '../../../constants/style.dart';
import '../../../routing/route_name.dart';
import '../../../utils/navigation.dart';
import '../../../utils/size_config.dart';
import '../../common/screen/offline_screen.dart';
import '../provider/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late var pro = Provider.of<LoginProvider>(context, listen: false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      pro.emailAddress = "";
    });
    super.initState();
  }

  @override
  void dispose() async {
    pro.emailAddress = "";

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Provider.of<InternetConnectionStatus>(context) ==
            InternetConnectionStatus.disconnected
        ? const OfflineScreen()
        : Scaffold(
            body: SingleChildScrollView(
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
                  const Background(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenHeight(16)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenHeight(16)),
                          child: const LogoWidget(
                            size: 60,
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(12),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            ConstantText.welcomeBack,
                            style: fontWeight600(
                                size: getProportionateScreenHeight(24)),
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        Consumer<LoginProvider>(
                            builder: (context, provider, _) {
                          return TextFieldWithError(
                              initialValue: "",
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
                        Consumer<LoginProvider>(builder: (context, pro, child) {
                          return InkWell(
                              onTap: () {
                                Navigation.navigateToScreen(
                                    context, RouteName.forgotPassword);
                                pro.isErr();
                              },
                              child: const ForgotPassword());
                        }),
                        Consumer<LoginProvider>(builder: (context, pro, _) {
                          return pro.isPasswordReset
                              ? FutureBuilder(
                                  future: pro.resetPasswordTimer(),
                                  builder: (context, snapshot) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: CustomColor.successStatusColor,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.info,
                                              color: Colors.green),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            ConstantText.passwordResetSuccess,
                                            style: fontWeight400(
                                              size: 14.0,
                                              color: CustomColor.subTitle2,
                                            ),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                              onTap: () {
                                                pro.closeResetPasswordTimer();
                                              },
                                              child: const Icon(Icons.close))
                                        ],
                                      ),
                                    );
                                  })
                              : const EmptyBox();
                        }),
                        const StatusContainer(),
                        Consumer<LoginProvider>(
                            builder: (context, provider, _) {
                          return Stack(
                            children: [
                              InkWell(
                                onTap: provider.isLoginButtonEnable
                                    ? () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        provider.login(context);
                                        // Provider.of<BottomNavigationBarProvider>(
                                        //         context,
                                        //         listen: false)
                                        //     .index;
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
                                      margin: const EdgeInsets.all(0),
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.transparent,
                                      height: getProportionateScreenHeight(52),
                                    )
                                  : const EmptyBox()
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
          ? const EmptyBox()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: getProportionateScreenHeight(52),
              margin: EdgeInsets.symmetric(
                  vertical: getProportionateScreenWidth(16)),
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(12),
                  horizontal: getProportionateScreenWidth(12)),
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
                    width: getProportionateScreenWidth(8),
                  ),
                  Text(
                    provider.isErrorStatus
                        ? ConstantText.invalidEmailAndPassword
                        : "Login Success",
                    style: fontWeight400(
                      size: getProportionateScreenHeight(14),
                      color: CustomColor.subTitle2,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                      onTap: () {
                        provider.closeDialog();
                      },
                      child: const Icon(Icons.close))
                ],
              ),
            );
    });
  }
}
