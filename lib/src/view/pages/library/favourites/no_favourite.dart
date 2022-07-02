import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/helpers/constants/style.dart';

class NoFavoutiesScreen extends StatelessWidget {
  const NoFavoutiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
Image.asset(Images.noFav,width: 200,),
Text(ConstantText.noSongHere,style: fontWeight500(size: 16.0),),
Text(ConstantText.yourfavNoAvailable,style: fontWeight400(color: CustomColor.subTitle),),
      ],
    );
  }
}