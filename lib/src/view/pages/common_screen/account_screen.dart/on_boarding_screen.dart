import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';

import 'components/background_image.dart';
import 'components/logo_image.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: Container(),
                  flex: 2,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LogoWithImage(
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
                    
              
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Navigation.navigateToScreen(context, "register/");
                          },
                          child: CustomButton(label:ConstantText.register,radius: 8,)),
                      Padding(
                        padding: const EdgeInsets.only(bottom:20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ConstantText.loginPrefix,
                              style: fontWeight500(size: 14.0),
                            ),
                            InkWell(
                              onTap: () {
                                 Navigation.navigateToScreen(context, "login/");
                         
                              },
                              child: Text(
                                " "+ConstantText.login,
                                style:
                                    fontWeight500(size: 14.0, color: Colors.red),
                              ),
                            ),
                          ],
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
   
    );
  }
}

class CenterTextWidget extends StatelessWidget {
  const CenterTextWidget({
    Key? key, required this.label, required this.topPadding, required this.textSize, required this.textColor,

  }) : super(key: key);
final String label;
final double topPadding;
final double textSize;
final Color textColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: topPadding),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: fontWeight500(size: textSize,color: textColor),
      ),
    );
  }
}

