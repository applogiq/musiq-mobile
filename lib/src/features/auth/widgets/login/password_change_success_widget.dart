import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/empty_box.dart';
import '../../../../constants/constant.dart';
import '../../provider/login_provider.dart';

class PasswordChangeSuccessWidget extends StatelessWidget {
  const PasswordChangeSuccessWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, pro, _) {
        return pro.isPasswordReset
            ? FutureBuilder(
                future: pro.resetPasswordTimer(),
                builder: (context, snapshot) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CustomColor.successStatusColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info, color: Colors.green),
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
                },
              )
            : const EmptyBox();
      },
    );
  }
}
