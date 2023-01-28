import 'package:flutter/material.dart';
import 'package:musiq/src/features/auth/provider/register_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget(
      {Key? key,
      required this.title,
      this.actions,
      this.height = 64.0,
      this.onBack})
      : super(key: key);
  final String title;
  final dynamic actions;
  final double height;
  final Function? onBack;
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<RegisterProvider>(context);
    return AppBar(
      toolbarHeight: height,
      titleSpacing: 0.1,
      leading: InkWell(
          onTap: () {
            if (onBack != null) {
              onBack!();
            }
            Navigator.of(context).pop();
            pro.clearError();
            // Provider.of<ForgotPasswordProvider>(context, listen: false)
            //     .isClearError();
          },
          child: const Icon(Icons.arrow_back_ios_rounded)),
      title: Text(title),
      actions: actions,
    );
  }
}
