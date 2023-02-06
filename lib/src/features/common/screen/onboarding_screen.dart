import 'package:flutter/material.dart';

import '../../../common_widgets/buttons/custom_elevated_button.dart';
import '../../../common_widgets/buttons/text_with_button.dart';
import '../../../common_widgets/image/auth_background.dart';
import '../../../common_widgets/image/logo_image.dart';
import '../../../common_widgets/text/center_text.dart';
import '../../../core/constants/color.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/string.dart';
import '../../../core/routing/route_name.dart';
import '../../../core/utils/navigation.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              const Background(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: SizedBox.expand(),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Hero(
                            tag: Images.heroImage,
                            child: const LogoWithImage(),
                          ),
                          CenterTextWidget(
                            label: ConstantText.slogan,
                            topPadding: 24.0,
                            textSize: 18,
                            textColor: Colors.white,
                          ),
                          CenterTextWidget(
                            label: ConstantText.subSlogan,
                            topPadding: 12.0,
                            textColor: CustomColor.subTitle2,
                            textSize: 14,
                          ),
                          const Spacer(),
                          CustomElevatedButton(
                            onTap: () {
                              Navigation.navigateToScreen(
                                  context, RouteName.register);
                            },
                            label: ConstantText.register,
                            radius: 8,
                          ),
                          TextWithButton(
                            unClickableText: ConstantText.loginPrefix,
                            clickableText: ConstantText.login,
                            navigationString: RouteName.login,
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
  }
}
