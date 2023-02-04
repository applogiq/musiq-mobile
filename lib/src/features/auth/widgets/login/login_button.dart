import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/buttons/custom_button.dart';
import '../../../../common_widgets/container/empty_box.dart';
import '../../../../constants/constant.dart';
import '../../../../utils/size_config.dart';
import '../../provider/login_provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, provider, _) {
      return Stack(
        children: [
          InkWell(
            onTap: provider.isLoginButtonEnable
                ? () {
                    FocusScope.of(context).requestFocus(FocusNode());
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
                  margin: const EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  height: getProportionateScreenHeight(52),
                )
              : const EmptyBox()
        ],
      );
    });
  }
}
