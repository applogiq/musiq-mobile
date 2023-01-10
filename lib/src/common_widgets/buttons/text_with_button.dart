import 'package:flutter/material.dart';
import 'package:musiq/src/features/auth/provider/login_provider.dart';
import 'package:provider/provider.dart';

import '../../constants/style.dart';
import '../../utils/navigation.dart';

class TextWithButton extends StatelessWidget {
  const TextWithButton({
    Key? key,
    required this.unClickableText,
    required this.clickableText,
    required this.navigationString,
  }) : super(key: key);
  final String unClickableText;
  final String clickableText;
  final String navigationString;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            unClickableText,
            style: fontWeight500(size: 14.0),
          ),
          InkWell(
            onTap: () {
              Navigation.navigateToScreen(context, navigationString);
              Provider.of<LoginProvider>(context, listen: false).isErr();
            },
            child: Text(
              " $clickableText",
              style: fontWeight500(size: 14.0, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
