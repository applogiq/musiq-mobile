import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/utils/play_navigation.dart';
import 'package:musiq/src/logic/services/api_call.dart';
import 'package:musiq/src/logic/services/api_route.dart';
import 'package:musiq/src/model/api_model/album_model.dart';
import 'package:musiq/src/model/api_model/aura_model.dart';
import 'package:musiq/src/view/pages/home/components/pages/recently_played_view_all.dart';
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

import '../../../model/api_model/recent_song_model.dart';

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
  late RecentlyPlayed recentlyPlayed;
  late Album album;
  late AuraModel auraModel;
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
    artistData= await apiRoute.getArtist(limit: 4);
    recentlyPlayed=await apiRoute.getRecentlyPlayed();
    album=await apiRoute.getAlbum();
    auraModel=await apiRoute.getAura();
    isLoad=true;
    setState(() {
      isLoad;
    });
  }
  // Future<RecentlyPlayed> getRecent()async{
  // await Future.delayed(Duration(seconds: 2),(){});
  //   var token=await storage.read(key: "access_token");
  //   var url=Uri.parse(APIConstants.RECENT_PLAYED,);
  //   var header={ 'Content-type': 'application/json',
  //             'Accept': 'application/json',
  //             "Authorization": "Bearer $token"
  //             };
  //   print(url);
  //   var res=await http.get(url,headers: header);
   
  //     var data=jsonDecode(res.body);
  //     print(data.toString());
    
  //      RecentlyPlayed RecentlyPlayed=RecentlyPlayed.fromMap(data);
  //      print(RecentlyPlayed.toMap());
     
  //   return RecentlyPlayed;
   
    
  // }


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
Container(
  child: Column(children: [
Padding(padding: const EdgeInsets.all(12.0),
child: 
 Row(
      children: [
        Text(
          "Recently Played",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>  RecentlyPlayedViewAll(songList: recentlyPlayed, title: 'Recently Played',
                imageURL:
                  "${APIConstants.SONG_BASE_URL}public/music/tamil/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumName[0].toUpperCase()}/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumName}/image/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumId.toString()}.png",
)));
          },
          child: Text(
            "View All",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: CustomColor.secondaryColor),
          ),
        )
      ],
    ),
),
Container(

      padding: EdgeInsets.only(top: 8),

      height: 200,

      child: ListView.builder(

        // reverse: true,

          scrollDirection: Axis.horizontal,

          shrinkWrap: true,

          physics: BouncingScrollPhysics(),

          itemCount: recentlyPlayed.records.length,

          itemBuilder: (context, index) => Row(

                children: [

                  index == 0

                      ? SizedBox(

                          width: 10,

                        )

                      : SizedBox(),

                  InkWell(
                    onTap: (){
    recentlyPlayedToPlayScreen(recentlyPlayed,context,index);
  },
                    child: Container(
                  
                      padding: EdgeInsets.fromLTRB(6, 8, 6, 0),
                  
                        width: 135,
                  
                      child: Column(
                  
                        mainAxisAlignment: MainAxisAlignment.start,
                  
                        crossAxisAlignment:
                  
                             CrossAxisAlignment.start,
                  
                        children: [
                  
                          CustomColorContainer(
                  
                            
                  
                            child: Image.network(
                  
                               "${APIConstants.SONG_BASE_URL}public/music/tamil/${recentlyPlayed.records[index].albumName[0].toUpperCase()}/${recentlyPlayed.records[index].albumName}/image/${recentlyPlayed.records[index].albumId.toString()}.png",
                  
                  
                  
                              height: 125,
                  
                              width: 135,
                  
                              fit: BoxFit.cover,
                  
                            ),
                  
                          ),
                  
                          SizedBox(
                  
                            height: 6,
                  
                          ),
                  
                          Text(
                  
                          recentlyPlayed.records[index].songName.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                  
                            style: TextStyle(
                  
                                fontWeight: FontWeight.w400, fontSize: 12),
                  
                          ),
                  
                          SizedBox(
                  
                            height: 2,
                  
                          ),
                  
                         Text( recentlyPlayed.records[index].albumName.toString()+"-"+recentlyPlayed.records[index].musicDirectorName[0].toString(),
                  
                         maxLines: 1,
                  
                      overflow: TextOverflow.ellipsis,
                  
                     
                  
                                  style: TextStyle(
                  
                                      fontWeight: FontWeight.w400,
                  
                                      fontSize: 12,
                  
                                      color: CustomColor.subTitle))
                  
                        ],
                  
                      ),
                  
                    ),
                  ),

                ],

              )),

    ),
  ],
  ),
),

    //     HorizonalListViewWidget(
    //             title: "Recently Played",
    //             actionTitle: "View All",
    //             listWidget: Container(
    //                 alignment: Alignment.center,
    //                 child: Container(
    //   padding: EdgeInsets.only(top: 8),
    //   height: 200,
    //   child: ListView.builder(
    //     reverse: true,
    //       scrollDirection: Axis.horizontal,
    //       shrinkWrap: true,
    //       physics: BouncingScrollPhysics(),
    //       itemCount: recentlyPlayed.records.length,
    //       itemBuilder: (context, index) => Row(
    //             children: [
    //               index == 0
    //                   ? SizedBox(
    //                       width: 10,
    //                     )
    //                   : SizedBox(),
    //               Container(
    //                 padding: EdgeInsets.fromLTRB(6, 8, 6, 0),
    //                   width: 135,
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   crossAxisAlignment:
    //                        CrossAxisAlignment.start,
    //                   children: [
    //                     CustomColorContainer(
                          
    //                       child: Image.network(
    //                          "${APIConstants.SONG_BASE_URL}public/music/tamil/${recentlyPlayed.records[index].name[0].toUpperCase()}/${recentlyPlayed.records[index].name}/image/${recentlyPlayed.records[index].albumId.toString()}.png",

    //                         height: 125,
    //                         width: 135,
    //                         fit: BoxFit.cover,
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 6,
    //                     ),
    //                     Text(
    //                     recentlyPlayed.records[index].songs!.name.toString(),
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.w400, fontSize: 12),
    //                     ),
    //                     SizedBox(
    //                       height: 2,
    //                     ),
    //                    Text( recentlyPlayed.records[index].name.toString()+"-"+recentlyPlayed.records[index].musicDirectorName[0].toString(),
    //                    maxLines: 1,
    // overflow: TextOverflow.ellipsis,
   
    //                             style: TextStyle(
    //                                 fontWeight: FontWeight.w400,
    //                                 fontSize: 12,
    //                                 color: CustomColor.subTitle))
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           )),
    // ),
    // ),
    // ),
        
        
            TrendingHitsWidget(),
            HorizonalListViewWidget(
                title: "Recommended songs",
                actionTitle: "",
                listWidget:
                    CustomHorizontalListview(images: images.recommendedSong)),
            ArtistListView(artist: artistData),
  
          
          
          
          
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
              listWidget: Container(
      padding: EdgeInsets.only(top: 8),
      height:  180 ,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: auraModel.records.length,
          itemBuilder: (context, index) => Row(
                children: [
                  index == 0
                      ? SizedBox(
                          width: 10,
                        )
                      : SizedBox(),
                  Container(
                    padding: EdgeInsets.fromLTRB(6, 8, 6, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:  CrossAxisAlignment.center
                          ,
                      children: [
                        CustomColorContainer(
                          shape: BoxShape.circle,
                          child: Image.network(
                            APIConstants.SONG_BASE_URL+APIConstants.AURA+auraModel.records[index].auraId+".png",
                            height: 125,
                            width: 125,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          auraModel.records[index].auraName,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                       
                      ],
                    ),
                  ),
                ],
              )),
    ),
            ),
    //             Column(
    //               children:[
    //              Container(
    //                 alignment: Alignment.center,
    //                 child: Container(
    //   padding: EdgeInsets.only(top: 8),
    //   height: 200,
    //   child: ListView.builder(
    //       scrollDirection: Axis.horizontal,
    //       shrinkWrap: true,
    //       physics: BouncingScrollPhysics(),
    //       itemCount: album.records.length,
    //       itemBuilder: (context, index) => Row(
    //             children: [
    //               index == 0
    //                   ? SizedBox(
    //                       width: 10,
    //                     )
    //                   : SizedBox(),
    //               Container(
    //                 padding: EdgeInsets.fromLTRB(6, 8, 6, 0),
    //                   width: 135,
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   crossAxisAlignment:
    //                        CrossAxisAlignment.start,
    //                   children: [
    //                     CustomColorContainer(
                          
    //                       child: Image.network(
    //                          "${APIConstants.SONG_BASE_URL}public/music/tamil/${album.records[index].albumName[0].toUpperCase()}/${album.records[index].albumName}/image/${album.records[index].albumId.toString()}.png",

    //                         height: 125,
    //                         width: 135,
    //                         fit: BoxFit.cover,
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 6,
    //                     ),
    //                     Text(
    //                     album.records[index].albumName,
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.w400, fontSize: 12),
    //                     ),
    //                     SizedBox(
    //                       height: 2,
    //                     ),
    //                    Text( album.records[index].musicDirectorName[0].toString(),
    //                    maxLines: 1,
    // overflow: TextOverflow.ellipsis,
   
    //                             style: TextStyle(
    //                                 fontWeight: FontWeight.w400,
    //                                 fontSize: 12,
    //                                 color: CustomColor.subTitle))
                  
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           )),
    // ))]),
            // HorizonalListViewWidget(
            //     title: "Top Albums",
            //     actionTitle: "",
            //     listWidget: CustomHorizontalListview(
            //       images: images.topAlbumList,
            //     )),
            Container(
  child: Column(children: [
Padding(padding: const EdgeInsets.all(12.0),
child:  Row(
      children: [
        Text(
          "Top Albums",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Spacer(),
//         InkWell(
//           onTap: () {
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) =>  RecentlyPlayedViewAll(songList: recentlyPlayed, title: 'Recently Played',
//                 imageURL:  "${APIConstants.SONG_BASE_URL}public/music/tamil/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumName[0].toUpperCase()}/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumName}/image/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumId.toString()}.png",
// )));
//           },
//           child: Text(
//             "View All",
//             style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//                 color: CustomColor.secondaryColor),
//           ),
//         )
    
      ],
    ),
),
Container(
      padding: EdgeInsets.only(top: 8),
      height: 200,
      child: ListView.builder(
        // reverse: true,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: album.records.length,
          itemBuilder: (context, index) => Row(
                children: [
                  index == 0
                      ? SizedBox(
                          width: 10,
                        )
                      : SizedBox(),
                  Container(
                    padding: EdgeInsets.fromLTRB(6, 8, 6, 0),
                      width: 135,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:
                           CrossAxisAlignment.start,
                      children: [
                        CustomColorContainer(
                          
                          child: Image.network(
                              "${APIConstants.SONG_BASE_URL}public/music/tamil/${album.records[index].albumName[0].toUpperCase()}/${album.records[index].albumName}/image/${album.records[index].albumId.toString()}.png",

                            height: 125,
                            width: 135,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                        album.records[index].albumName.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                       Text(album.records[index].musicDirectorName[0].toString(),
                       maxLines: 1,
    overflow: TextOverflow.ellipsis,
   
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: CustomColor.subTitle))
                      ],
                    ),
                  ),
                ],
              )),
    ),
  ],
  ),
),

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
