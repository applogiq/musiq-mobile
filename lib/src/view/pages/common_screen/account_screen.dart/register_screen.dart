import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/select_your%20fav_artist.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/on_boarding_screen.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';

import '../../profile/components/my_profile.dart';
import 'components/background_image.dart';
import 'components/logo_image.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 118,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: LogoWidget(
                      size: 60,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Get started",
                    style: fontWeight600(size: 24.0),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  title: "Full Name",
                ),
                CustomTextField(
                  title: "Username",
                ),
                CustomTextField(
                  title: "Email Address",
                ),
                CustomTextField(
                  title: "Password",
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0, bottom: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SelectYourFavList()));
                    },
                    child: CustomButton(
                      label: "Create account",
                      margin: 0,
                    ),
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
