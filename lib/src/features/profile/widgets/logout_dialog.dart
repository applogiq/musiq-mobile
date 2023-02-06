// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:musiq/src/features/common/screen/onboarding_screen.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/auth.dart';
import '../../../core/utils/navigation.dart';
import '../../../core/utils/size_config.dart';
import '../../auth/provider/register_provider.dart';

showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromRGBO(33, 33, 44, 1),
        title: const Center(child: Text("Sign Out")),
        content: const Text(
          "Are you sure you want to Sign Out?",
          style: TextStyle(fontSize: 12),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: getProportionateScreenHeight(44),
              width: getProportionateScreenWidth(120),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromRGBO(255, 255, 255, 0.1)),
              child: const Center(child: Text("Cancel")),
            ),
          ),
          GestureDetector(
            onTap: () async {
              Auth auth = Auth();
              await auth.logOut();
              context.read<PlayerProvider>().removeAllData();

              Provider.of<RegisterProvider>(context, listen: false)
                  .clearError();
              Provider.of<RegisterProvider>(context, listen: false)
                  .isButtonEnable = true;
              await Navigation.removeAllScreenFromStack(
                  context, const OnboardingScreen());
            },
            child: Container(
              height: getProportionateScreenHeight(44),
              width: getProportionateScreenWidth(120),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromRGBO(254, 86, 49, 1)),
              child: const Center(child: Text("Confirm")),
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(5),
          )
        ],
      );
    },
  );
}
