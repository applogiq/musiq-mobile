import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/helpers/constants/style.dart';

class NoSongScreen extends StatelessWidget {
   NoSongScreen({Key? key,this.isFav=false, required this.mainTitle, required this.subTitle,}) : super(key: key);
  bool isFav;
  final String mainTitle;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
Image.asset(Images.noFav,width: 200,),
Text(mainTitle,style: fontWeight500(size: 16.0),),
Text(subTitle,style: fontWeight400(color: CustomColor.subTitle),),
        ],
      ),
    );
  }
}