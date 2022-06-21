import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:musiq/src/helpers/constants/api.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/logic/services/api_call.dart';
import 'package:musiq/src/model/api_model/artist_model.dart';
import 'package:musiq/src/view/pages/home/components/pages/search_screen.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';
import 'package:musiq/src/view/pages/profile/components/artist_preference_screen.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';
import 'package:musiq/src/view/widgets/empty_box.dart';

import '../../../../helpers/constants/color.dart';
import '../../../../helpers/constants/style.dart';
import '../../../widgets/custom_color_container.dart';
import '../../bottom_navigation_bar.dart';
import 'package:http/http.dart' as http;

class SelectYourFavList extends StatefulWidget {
   SelectYourFavList({Key? key,this.artist_list}) : super(key: key);
  List? artist_list=[]; 

  @override
  State<SelectYourFavList> createState() => _SelectYourFavListState();
}

class _SelectYourFavListState extends State<SelectYourFavList> {
  var storage=FlutterSecureStorage();
    APICall apiCall=APICall();
    var data;
    var isLoadingList=[];
    var isLoad=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    data=getArtist();
    
    
    // getArtist();
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
      for(int i=0;i<artistModel.records.length;i++){
        isLoadingList.add(false);
      }
      print(isLoadingList);
      // print(artistModel.records.toString());
      // print(artistModel.toMap());
    return artistModel;
    
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([
     SystemUiOverlay.top, //This line is used for showing the bottom bar
  ]);
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
              //   child: SearchTextWidget(
              //     onTap: () {},
              //     hint: "Search Artists",
              //   ),
              // ),
          
              Expanded(
                  child: FutureBuilder<ArtistModel>(future: data,builder: (context, snapshot) {
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return Center(child: Image.asset(Images.loaderImage,height: 70,),);
                    }
                    else if(snapshot.hasData!=null){
                      var record=snapshot.data!.records;
                      print(record.toString());
                      return   ListView.builder(shrinkWrap: true,itemCount: record.length,itemBuilder: (context,index){
                        return Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: CustomColorContainer(
                                        child: Image.network(
                                          
                                         record[index].isImage? APIConstants.BASE_IMAGE_URL+record[index].artistId+".png":"https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/450px-No_image_available.svg.png",
                                         
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.fill,                                               
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 7,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(4.0, 8.0, 8.0, 8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                        record[index].name,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                                            ),
                                            Row(
                        children: [
                          Icon(Icons.people),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            record[index].followers!=null?record[index].followers.toString():"0",
                            style: TextStyle(
                                color: CustomColor.subTitle,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ],
                                            ),
                                          ],
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: widget.artist_list!.contains(record[index].artistId) ? 4 : 16,
                                            vertical: 4),
                                        child: InkWell(
                                          onTap: ()async {
                                            print(record[index].artistId);
                                            if(widget.artist_list!.contains(record[index].artistId)){
                          Map<String, dynamic> params = {
                        
                        "artist_id": record[index].artistId,
                        "follow": false
                        };
                                            var res=  await apiCall.putRequestWithAuth(APIConstants.ARTIST_FOLLOWING,params);
                        if(res.statusCode==200){
                        
                                         widget.artist_list!.remove(record[index].artistId);
                        }
                                             
                                            }
                                            else{
                            Map<String, dynamic> params = {
                        
                        "artist_id": record[index].artistId,
                        "follow": true
                        };
                                            var res=  await apiCall.putRequestWithAuth(APIConstants.ARTIST_FOLLOWING,params);
                        if(res.statusCode==200){
                        
                                            widget.artist_list!.add(record[index].artistId);
                        }
                                            // print(widget.artist_list!.length);
                                            }
                                            setState(() {
                        widget.artist_list;
                        // data=getArtist();
                                            });
                                            // var temp1 = widget.images[index].isFollowing;
                                            // var temp2 = widget.images[index].subTitle;
                                            // var temp3 = widget.images[index].title;
                                            // var temp4 = widget.images[index].imageURL;
                                            // print(temp1);
                                            // print(temp2);
                                            // print(temp3);
                                            // // String imageUrl=widget.images[index].
                        
                                            // widget.images.removeAt(index);
                                            // widget.images.insert(
                                            //     index,
                                            //     ArtistImageModel(
                                            //         imageURL: temp4,
                                            //         title: temp3,
                                            //         subTitle: temp2,
                                            //         isFollowing: temp1 != temp1));
                                            // print(widget.images[index].isFollowing);
                                            // setState(() {
                                            //   widget.images[index].isFollowing !=
                                            //       widget.images[index].isFollowing;
                                            // });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                          horizontal: widget.artist_list!.contains(record[index].artistId) ? 6 : 2,
                          vertical: 4),
                                            decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: 
                        widget.artist_list!.contains(record[index].artistId)
                            ? CustomColor.followingColor
                            : 
                            CustomColor.secondaryColor,
                                            ),
                                            child: Center(
                        child: Text(
                          widget.artist_list!.contains(record[index].artistId)
                              ? "Following"
                              :
                               "Follow",
                          style: fontWeight400(),
                        ),
                                            ),
                                          ),
                                        ),
                                      ))
                               
                                ],
                              ),
                            )
    ;
                      });
                    }
                    return Text("data");
                  }))
            ],
          ),
      isLoad?Container(height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(.5),
      child: Center(child: Image.asset(Images.loaderImage,height: 70,),),):EmptyBox()
        ],
      ),
      bottomNavigationBar:widget.artist_list!.length<3?
      EmptyBox()
      :isLoad?EmptyBox(): InkWell(
          onTap: ()async {
            isLoad=true;
            setState(() {
              isLoad;
            });
            Future.delayed(Duration(seconds: 2),(){
isLoad=false;
            setState(() {
              isLoad;
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) => CustomBottomBar()));
            });
            });
          },
          child: CustomButton(label: "Save")),
    );
  }
}
   // CustomArtistVerticalList(
                  //   images: Images().artistPrefList,
                  // ),