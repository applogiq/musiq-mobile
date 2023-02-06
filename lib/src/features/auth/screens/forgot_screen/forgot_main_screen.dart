import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/app_bar.dart';
import '../../../../common_widgets/box/vertical_box.dart';
import '../../../../common_widgets/buttons/custom_button.dart';
import '../../../../common_widgets/text_field/custom_text_field.dart';
import '../../../../core/constants/string.dart';
import '../../../common/screen/offline_screen.dart';
import '../../provider/forgot_password_provider.dart';

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
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.maxFinite, 80),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CustomAppBarWidget(
                title: ConstantText.forgotPassword2,
              ),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
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
                              initialValue: "",
                              errorMessage: provider.emailAddressErrorMessage,
                              label: ConstantText.email,
                              onTap: () {},
                              isValidatorEnable: true,
                              onChange: (text) {
                                provider.emailChanged(text);
                              }),
                        );
                      }),
                      const VerticalBox(height: 60),
                      Consumer<ForgotPasswordProvider>(
                        builder: (context, value, child) {
                          return GestureDetector(
                            onTap: () {
                              value.emailVerfied(context);
                            },
                            child: CustomButton(
                              label: ConstantText.continueButton,
                              horizontalMargin: 0,
                              isValid: value.isEmailButtonEnable,
                              isLoading: value.isEmailLoading,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Provider.of<InternetConnectionStatus>(context) ==
                      InternetConnectionStatus.disconnected
                  ? const OfflineScreen()
                  : const SizedBox.shrink()
            ],
          )),
    );
  }
}
