import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/logic/services/api_call.dart';
import 'package:musiq/src/logic/services/api_route.dart';
import 'package:musiq/src/view/pages/home/components/pages/search_screen.dart';
import 'package:musiq/src/view/pages/home/components/pages/view_all_screen.dart';
import 'package:musiq/src/view/pages/home/components/widget/artist_list_view.dart';
import 'package:musiq/src/view/pages/home/components/widget/horizontal_list_view.dart';
import 'package:musiq/src/view/pages/home/components/widget/loader.dart';
import 'package:musiq/src/view/pages/home/components/widget/trending_hits.dart';
import 'package:musiq/src/view/pages/home/components/widget/vertical_list_view.dart';
import 'package:musiq/src/view/widgets/custom_color_container.dart';

import '../../../helpers/constants/api.dart';
import '../../../model/api_model/artist_model.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key,}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Images images = Images();
  var storage=const FlutterSecureStorage();
  APIRoute apiRoute=APIRoute();
  var artistData;
  bool isLoad=false;
   
  // Api
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }
  getData()async{
    isLoad=false;
    setState(() {
      isLoad;
    });
    artistData= await apiRoute.getArtist();
    isLoad=true;
    setState(() {
      isLoad;
    });
  }
  Future<ArtistModel> getArtist()async{
  await Future.delayed(Duration(seconds: 2),(){});
    var token=await storage.read(key: "access_token");
    var url=Uri.parse(APIConstants.BASE_URL+APIConstants.ARTIST_LIST,);
    var header={ 'Content-type': 'application/json',
              'Accept': 'application/json',
              "Authorization": "Bearer $token"
              };
    print(url);
    var res=await http.get(url,headers: header);
   
      var data=jsonDecode(res.body);
      print(data.toString());
      ArtistModel artistModel=ArtistModel.fromMap(data);
      // for(int i=0;i<artistModel.records.length;i++){
      //   isLoadingList.add(false);
      // }
      // print(isLoadingList);
      // print(artistModel.records.toString());
      // print(artistModel.toMap());
    return artistModel;
    
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
        isLoad==false?
        LoaderScreen()
        :
         ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SearchTextWidget(
                        isReadOnly: true,
                        onTap: () {
                          print("DATA");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SearchScreen()));
                        },
                        hint: "Search Music and Podcasts",
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CustomColorContainer(
                      bgColor: CustomColor.textfieldBg,
                      left: 12,
                      verticalPadding: 6,
                      child: Center(
                        child: Stack(
                          children: [
                            Icon(Icons.notifications),
                            Positioned(
                              right: 2,
                              child: new Container(
                                padding: EdgeInsets.all(4.5),
                                decoration: new BoxDecoration(
                                  color: CustomColor.secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            HorizonalListViewWidget(
                title: "Recently Played",
                actionTitle: "View All",
                listWidget: Container(
                    alignment: Alignment.center,
                    child: CustomHorizontalListview(
                        images: images.recentlyPlayed))),
            TrendingHitsWidget(),
            HorizonalListViewWidget(
                title: "Recommended songs",
                actionTitle: "",
                listWidget:
                    CustomHorizontalListview(images: images.recommendedSong)),
            ArtistListView(artist: artistData),
//           Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
//           child: ListHeaderWidget(
//             title: "Artists",
//             actionTitle: "View All",
//             isArtist: true,
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.only(top: 4),
//           height: 300,
//           child: FutureBuilder<ArtistModel>(
//             future: getArtist(),
//             builder: (context,snapShot) {
//               if(snapShot.connectionState==ConnectionState.waiting){
//                 return Center(child: CircularProgressIndicator(),);
//               }
//               else if(snapShot.data==null){
//                 return Center(child: Text("No Data"),);
//               }
//               else{
                
//                   var record=snapShot.data!.records;
                   
//                         return ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   shrinkWrap: true,
//                   physics: BouncingScrollPhysics(),
//                   itemCount: snapShot.data!.records.length,
//                   itemBuilder: (context, index) => Row(
//                         children: [
//                           index == 0
//                               ? SizedBox(
//                                   width: 12,
//                                 )
//                               : SizedBox(),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 6),
//                             child: InkWell(
//                               onTap: ()async{
//                                 Map<String, String> queryParams = {
//   'artist_id': record[index].id.toString(),
//   'skip': '0',
//   'limit': '100',
// };
// Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewAllScreen(title:record[index].name,imageURL: record[index].isImage? APIConstants.BASE_IMAGE_URL+record[index].artistId+".png":"https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/450px-No_image_available.svg.png",
//                                          )));
// // APICall apiCall=APICall();
// // var res=await apiCall.getRequestWithAuth("endPoint", queryParams);


//                               },
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CustomColorContainer(
//                                     child: Image.network(
//                                           record[index].isImage? APIConstants.BASE_IMAGE_URL+record[index].artistId+".png":"https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/450px-No_image_available.svg.png",
                                           
//                                       height: 240,
//                                       width: 200,
//                                       fit: BoxFit.cover,
                                     
//                                                 errorBuilder: (context, error, stackTrace) {
//                                         return Container(
//                                           color: Colors.amber,
//                                           alignment: Alignment.center,
//                                           child: const Text(
//                                             'Whoops!',
//                                             style: TextStyle(fontSize: 30),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 6,
//                                   ),
//                                   Text(
//                                     record[index].name,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w400, fontSize: 14),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ));
      
//               }
//             }
//           ),
//         )
//       ],
//     ),
  
          
          
          
          
            HorizonalListViewWidget(
                title: "New Releases",
                actionTitle: "",
                listWidget: CustomHorizontalListview(
                  images: images.podcastList,
                )),
            // Container(
            //   padding: EdgeInsets.all(8.0),
            //   child: Column(
            //     children: [
            //       ListHeaderWidget(
            //           title: "Based on your Interest", actionTitle: "View All"),
            //       Container(
            //           margin: EdgeInsets.only(top: 10),
            //           child: CustomSongVerticalList(
            //               images: images.basedOnYourInterestList))
            //     ],
            //   ),
            // ),
            HorizonalListViewWidget(
              title: "Current Mood",
              actionTitle: "",
              listWidget: CustomHorizontalListview(
                shape: BoxShape.circle,
                alignText: TextAlign.center,
                images: images.currentMoodList,
              ),
            ),
            HorizonalListViewWidget(
                title: "Top Albums",
                actionTitle: "",
                listWidget: CustomHorizontalListview(
                  images: images.topAlbumList,
                )),
          ],
        ),
      ),
    );
  }
}

class SearchTextWidget extends StatelessWidget {
  SearchTextWidget({
    Key? key,
    required this.hint,
    this.isReadOnly = false,
    required this.onTap,
  }) : super(key: key);
  final String hint;
  bool isReadOnly;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomColorContainer(
      left: 1,
      verticalPadding: 2,
      bgColor: CustomColor.textfieldBg,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(height: 40, width: double.maxFinite),
        child: TextField(
          onTap: onTap,
          readOnly: isReadOnly,
          onChanged: (val) {},
          cursorColor: Colors.white,
          decoration: InputDecoration(
              prefixIcon: Container(
                padding: EdgeInsets.all(12),
                child: Image.asset(
                  "assets/icons/search.png",
                  height: 16,
                  width: 16,
                  color: Colors.white,
                ),
              ),
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 14),
              hintText: hint),
        ),
      ),
    );
  }
}
