import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musiq/src/logic/controller/view_all_controller.dart';
import 'package:musiq/src/view/pages/home/components/pages/recently_played_view_all.dart';
import 'package:musiq/src/view/pages/home/components/widget/loader.dart';

import '../../../../../helpers/constants/api.dart';

class TrendingHitsViewAll extends StatelessWidget {
  const TrendingHitsViewAll({Key? key, required this.title}) : super(key: key);
 final String title;
  @override
  Widget build(BuildContext context) {
    final ViewAllController viewAllController=Get.put(ViewAllController());
    viewAllController.trendingHitsViewAll();
     var size = MediaQuery.of(context).size;

    return Obx(()=>viewAllController.isLoaded.value?SafeArea(child:Scaffold(
              appBar: PreferredSize(preferredSize: Size(size.width,viewAllController.scrollPosition.value==0.0? size.height/2.5:80),
              child:viewAllController.scrollPosition.value==0.0? 
               PrimaryAppBar(isNetworkImage: true, imageURL: viewAllController.defaultImage
, title: title,height: size.height/2.5,)
              :SecondaryAppBar(title: title))
        ),):LoaderScreen());
  }
}