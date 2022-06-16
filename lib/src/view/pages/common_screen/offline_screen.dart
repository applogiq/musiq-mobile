import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        children: [
          Spacer(),
          Image.asset(Images.noInternet,width: 95,),

          Padding(
            padding: const EdgeInsets.only(top:24,bottom: 9),
            child: Text(ConstantText.noInternet,style: fontWeight600(),),
          ),
          Text(ConstantText.pleaseTry,style: fontWeight400(color: CustomColor.subTitle2),),
          Padding(
            padding: const EdgeInsets.only(top: 44),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 140),
              child: CustomButton(label: ConstantText.retry,margin: 0.0,),
            ),
          ),
          Spacer(),
        
        ],),
      )
      ,
    );
  }
}