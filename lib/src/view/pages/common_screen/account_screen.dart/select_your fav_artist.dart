// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
// import 'package:musiq/src/helpers/constants/api.dart';
// import 'package:musiq/src/helpers/constants/images.dart';
// import 'package:musiq/src/logic/services/api_call.dart';
// import 'package:musiq/src/logic/services/api_route.dart';
// import 'package:musiq/src/model/api_model/artist_model.dart' as art;
// import 'package:musiq/src/model/api_model/song_list_model.dart';
// import 'package:musiq/src/view/pages/home/components/pages/search_screen.dart';
// import 'package:musiq/src/view/pages/home/components/widget/loader.dart';
// import 'package:musiq/src/view/pages/home/home_screen.dart';
// import 'package:musiq/src/view/pages/profile/components/artist_preference_screen.dart';
// import 'package:musiq/src/view/widgets/custom_button.dart';
// import 'package:musiq/src/view/widgets/empty_box.dart';

// import '../../../../helpers/constants/color.dart';
// import '../../../../helpers/constants/style.dart';
// import '../../../widgets/custom_color_container.dart';
// import '../../bottom_navigation_bar.dart';
// import 'package:http/http.dart' as http;

// class SelectYourFavList extends StatefulWidget {
//    SelectYourFavList({Key? key,this.artist_list}) : super(key: key);
//   List? artist_list=[]; 

//   @override
//   State<SelectYourFavList> createState() => _SelectYourFavListState();
// }

// class _SelectYourFavListState extends State<SelectYourFavList> {
//   var storage=FlutterSecureStorage();
//     APIRoute apiRoute=APIRoute();
//     APICall apiCall=APICall();
//     var data;
//    var followList=[];
//     var isLoad=false;
//   @override
//   void initState() {
  
//     super.initState();
    
   
//     data=getArtist();
  
//   }
//   Future<art.ArtistModel> getArtist()async{
//     return await apiRoute.getArtist();

//   }

 
//   followAndUnfollow(var record,int index)async{
//     print("CHECK FUNCTION");
//     print(widget.artist_list);
// // if(widget.artist_list!.isEmpty){
// //    record[index].followers=(record[index].followers! +1);
// //       widget.artist_list!.add(record[index].artistId);
// //            record[index].followers=(record[index].followers! +1);
// //                                                 widget.artist_list!.add(record[index].artistId);
// //                                                     Map<String, dynamic> params = {
                        
// //                         "artist_id": record[index].artistId,
// //                         "follow": true
// //                         };
// //                                             var res=  await apiCall.putRequestWithAuth(APIConstants.ARTIST_FOLLOWING,params);
// //                                             print(res.statusCode);

// //                         if(res.statusCode==200){
// //                         print("Foolow");
// //                         }
// // }
// //     else 
    
//     // if(widget.artist_list!.contains(record[index].artistId)){
//     //   record[index].followers=(record[index].followers! -1);

//     //      widget.artist_list!.remove(record[index].artistId);
//     //                         Map<String, dynamic> params = {
                        
//     //                     "artist_id": record[index].artistId,
//     //                     "follow": false
//     //                     };
//     //                                         var res=  await apiCall.putRequestWithAuth(APIConstants.ARTIST_FOLLOWING,params);
//     //                                         print(res.statusCode);
//     //                                         if(res.statusCode==200){
//     //                                           print("Un Follow");
//     //                                         }
        
//     // }
//     // else{


//     //    widget.artist_list!.add(record[index].artistId);
//     //                           record[index].followers=(record[index].followers! +1);
//     //                                             widget.artist_list!.add(record[index].artistId);
//     //                                                 Map<String, dynamic> params = {
                        
//     //                     "artist_id": record[index].artistId,
//     //                     "follow": true
//     //                     };
//     //                                         var res=  await apiCall.putRequestWithAuth(APIConstants.ARTIST_FOLLOWING,params);
//     //                                         print(res.statusCode);

//     //                     if(res.statusCode==200){
//     //                     print("Foolow");
//     //                     }
//     // }
// setState(() {
//   widget.artist_list;
// });
//                         //                     if(widget.artist_list!.contains(record[index].artistId)){
                                             
//                         //                       record[index].followers=(record[index].followers! -1);
                                             

//                         //                    widget.artist_list!.remove(record[index].artistId);
//                         //    Map<String, dynamic> params = {
                        
//                         // "artist_id": record[index].artistId,
//                         // "follow": false
//                         // };
//                         //                     var res=  await apiCall.putRequestWithAuth(APIConstants.ARTIST_FOLLOWING,params);
//                         //                     print(res.statusCode);
//                         //                     if(res.statusCode==200){
//                         //                       print("Un Follow");
//                         //                     }
                       
                       

//                         //                     }
//                         //                     else{
//                         //                        record[index].followers=(record[index].followers! +1);
//                         //                         widget.artist_list!.add(record[index].artistId);
//                         //                             Map<String, dynamic> params = {
                        
//                         // "artist_id": record[index].artistId,
//                         // "follow": true
//                         // };
//                         //                     var res=  await apiCall.putRequestWithAuth(APIConstants.ARTIST_FOLLOWING,params);
//                         //                     print(res.statusCode);

//                         // if(res.statusCode==200){
//                         // print("Foolow");
//                         // }
//                         //                     }
//                         //                     setState(() {
//                         //                       widget.artist_list;
//                         //                       record;
//                         //                     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setEnabledSystemUIOverlays([
//      SystemUiOverlay.top, //This line is used for showing the bottom bar
//   ]);
//     return Scaffold(
//       appBar: PreferredSize(preferredSize: Size(MediaQuery.of(context).size.width, 80),
//       child: ArtistPreferenceAppBarWidget(),),
//       body: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           Column(
//             children: [
           
//               Expanded(
//                   child: FutureBuilder<art.ArtistModel>(future: data,builder: (context, snapshot) {
//                     if(snapshot.connectionState==ConnectionState.waiting){
//                       return Center(child: Image.asset(Images.loaderImage,height: 70,),);
//                     }
//                     else if(snapshot.hasData!=null){
//                       List<art.Record> record=snapshot.data!.records;
//                       print(record.toString());
//                       return   ListView.builder(shrinkWrap: true,itemCount: record.length,itemBuilder: (context,index){
//                         return Container(
//                               alignment: Alignment.centerLeft,
//                               padding: EdgeInsets.all(8),
//                               child: Row(
//                                 children: [
//                                   Align(
//                                     alignment: Alignment.centerLeft,
//                                     child: CustomColorContainer(
//                                       child:record[index].isImage==false?Image.asset("assets/images/default/no_artist.png",width: 80,
//                                         height: 80,
//                                         ): Image.network(
//                                          APIConstants.BASE_IMAGE_URL+record[index].artistId+".png",
//                                         width: 80,
//                                         height: 80,
//                                         fit: BoxFit.fill,                                               
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                       flex: 7,
//                                       child: Padding(
//                                         padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                         record[index].artistName,
//                         style: TextStyle(
//                             fontWeight: FontWeight.w400, fontSize: 14),
//                                             ),
//                                             Row(
//                         children: [
//                           Icon(Icons.people),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             record[index].followers!=null?record[index].followers.toString():"0",
//                             style: TextStyle(
//                                 color: CustomColor.subTitle,
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 14),
//                           ),
//                         ],
//                                             ),
//                                           ],
//                                         ),
//                                       )),
//                                   Expanded(
//                                       flex: 4,
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: widget.artist_list!.contains(record[index].artistId) ? 4 : 16,
//                                             vertical: 4),
//                                         child: InkWell(
//                                           onTap: ()async {
                                          
                                          
//                                         followAndUnfollow(record, index);
//                                           },
//                                           child: Container(
//                                             alignment: Alignment.centerRight,
//                                             padding: EdgeInsets.symmetric(
//                           horizontal: widget.artist_list!.contains(record[index].artistId) ? 6 : 2,
//                           vertical: 4),
//                                             decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(6),
//                         color: 
//                         widget.artist_list!.contains(record[index].artistId)
//                             ? CustomColor.followingColor
//                             : 
//                             CustomColor.secondaryColor,
//                                             ),
//                                             child: Center(
//                         child: Text(
//                           widget.artist_list!.contains(record[index].artistId)
//                               ? "Unfollow"
//                               :
//                                "Follow",
//                           style: fontWeight400(),
//                         ),
//                                             ),
//                                           ),
//                                         ),
//                                       ))
                               
//                                 ],
//                               ),
//                             )
//     ;
//                       });
//                     }
//                     return Text("data");
//                   }))
         
//             ],
//           ),
//       isLoad?LoaderScreen():EmptyBox()
//         ],
//       ),
//       bottomNavigationBar:(widget.artist_list!.length<2|| widget.artist_list==null)?
//       EmptyBox()
//       :isLoad?EmptyBox(): InkWell(
//           onTap: ()async {
//             isLoad=true;
//             setState(() {
//               isLoad;
//             });
//             Future.delayed(Duration(seconds: 2),(){
// isLoad=false;
//             setState(() {
//               isLoad;
//             Navigator.of(context)
//                 .pushReplacement(MaterialPageRoute(builder: (context) => CustomBottomBar()));
//             });
//             });
//           },
//           child: CustomButton(label: "Save")),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../../home/components/pages/search_screen.dart';

class ArtistPreferenceAppBarWidget extends StatelessWidget {
  const ArtistPreferenceAppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: Text("Select 3 or more of your \nfavourite artists"),
      actions: [Padding(
        padding: const EdgeInsets.symmetric(horizontal:16.0),
        child: GestureDetector(
          onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchScreen()));},
          child: Image.asset(
                    "assets/icons/search.png",
                    height: 18,
                    width: 18,
                    color: Colors.white,
                  ),
        ),
      ),],
    );
  }
}
//    // CustomArtistVerticalList(
//                   //   images: Images().artistPrefList,
//                   // ),