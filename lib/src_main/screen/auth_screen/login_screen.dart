import 'package:flutter/material.dart';
import 'package:musiq/src_main/route/route_name.dart';
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
    final loginProvider = Provider.of<LoginProvider>(context);
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
                        TextFieldWithError(
                            onTap: () {},
                            label: ConstantText.email,
                            errorMessage:
                                loginProvider.emailAddressErrorMessage,
                            isValidatorEnable: true,
                            onChange: (text) {
                              loginProvider.emailAddressChanged(text);
                            }),
                        PasswordTextFieldWithError(
                            onTap: () async {
                              loginProvider.passwordTap();
                            },
                            isPassword: true,
                            label: ConstantText.password,
                            errorMessage: loginProvider.passwordErrorMessage,
                            isValidatorEnable: true,
                            onChange: (text) {
                              loginProvider.passwordChanged(text);
                            }),
                        InkWell(
                            onTap: () => Navigation.navigateToScreen(
                                context, RouteName.forgotPassword),
                            child: ForgotPassword()),
                        InkWell(
                          onTap: loginProvider.login(),
                          child: CustomButton(
                            label: ConstantText.login,
                            horizontalMargin: 0,
                          ),
                        ),
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
