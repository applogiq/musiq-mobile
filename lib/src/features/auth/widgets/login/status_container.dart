import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/empty_box.dart';
import '../../../../constants/constant.dart';
import '../../../../utils/size_config.dart';
import '../../provider/login_provider.dart';

class StatusContainer extends StatelessWidget {
  const StatusContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, provider, _) {
        return provider.isShowStatus == false
            ? const EmptyBox()
            : Container(
                width: MediaQuery.of(context).size.width,
                height: getProportionateScreenHeight(52),
                margin: EdgeInsets.symmetric(
                    vertical: getProportionateScreenWidth(16)),
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(12),
                    horizontal: getProportionateScreenWidth(12)),
                decoration: BoxDecoration(
                  color: provider.isErrorStatus
                      ? CustomColor.errorStatusColor
                      : CustomColor.successStatusColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info,
                        color:
                            provider.isErrorStatus ? Colors.red : Colors.green),
                    SizedBox(
                      width: getProportionateScreenWidth(8),
                    ),
                    Text(
                      provider.isErrorStatus
                          ? ConstantText.invalidEmailAndPassword
                          : ConstantText.loginSuccess,
                      style: fontWeight400(
                        size: getProportionateScreenHeight(14),
                        color: CustomColor.subTitle2,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                        onTap: () {
                          provider.closeDialog();
                        },
                        child: const Icon(Icons.close))
                  ],
                ),
              );
      },
    );
  }
}
