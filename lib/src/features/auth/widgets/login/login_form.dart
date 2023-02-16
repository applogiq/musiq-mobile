import 'package:flutter/material.dart';
import 'package:musiq/src/features/auth/widgets/login/password_change_success_widget.dart';
import 'package:musiq/src/features/auth/widgets/login/status_container.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/buttons/text_with_button.dart';
import '../../../../common_widgets/image/logo_image.dart';
import '../../../../common_widgets/text/forgot_password.dart';
import '../../../../common_widgets/text_field/custom_password_text_field.dart';
import '../../../../common_widgets/text_field/custom_text_field.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/routing/route_name.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/utils/size_config.dart';
import '../../provider/login_provider.dart';
import 'login_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(16)),
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
              style: fontWeight600(size: getProportionateScreenHeight(24)),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          Consumer<LoginProvider>(builder: (context, provider, _) {
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
          Consumer<LoginProvider>(builder: (context, provider, _) {
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
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                  onTap: () {
                    Navigation.navigateToScreen(
                        context, RouteName.forgotPassword);
                    pro.isErr();
                  },
                  child: const ForgotPassword()),
            );
          }),
          const PasswordChangeSuccessWidget(),
          const StatusContainer(),
          const LoginButton(),
          TextWithButton(
              unClickableText: ConstantText.registerPrefix,
              clickableText: ConstantText.register,
              navigationString: RouteName.register)
        ],
      ),
    );
  }
}
