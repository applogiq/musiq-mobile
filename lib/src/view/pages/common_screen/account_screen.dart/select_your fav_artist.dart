import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/helpers/constants/api.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/model/api_model/artist_model.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';
import 'package:musiq/src/view/pages/profile/components/artist_preference_screen.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';

import '../../../../helpers/constants/color.dart';
import '../../../../helpers/constants/style.dart';
import '../../../widgets/custom_color_container.dart';
import '../../bottom_navigation_bar.dart';
import 'package:http/http.dart' as http;

class SelectYourFavList extends StatefulWidget {
  const SelectYourFavList({Key? key}) : super(key: key);

  @override
  State<SelectYourFavList> createState() => _SelectYourFavListState();
}

class _SelectYourFavListState extends State<SelectYourFavList> {
  var storage=FlutterSecureStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      ArtistModel artistModel=ArtistModel.fromMap(data);
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
        title: Text("Select your favourite artists"),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
                child: SearchTextWidget(
                  onTap: () {},
                  hint: "Search Artists",
                ),
              ),
              Expanded(
                  child: FutureBuilder<ArtistModel>(future: getArtist(),builder: (context, snapshot) {
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return Center(child: Image.asset(Images.loaderImage,height: 60,),);
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
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomColorContainer(
                  child: Image.network(
                    APIConstants.BASE_IMAGE_URL+record[index].artistId+".png",
                    height: 70,
                    width: 70,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 5,
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
                            record[index].followers.toString(),
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
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      // horizontal: widget.images[index].isFollowing ? 8 : 16,
                      vertical: 4),
                  child: InkWell(
                    onTap: () {
                      print(record[index].artistId);
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
                          // horizontal: widget.images[index].isFollowing ? 8 : 16,
                          vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: 
                        // widget.images[index].isFollowing
                        //     ? CustomColor.followingColor
                        //     : 
                            CustomColor.secondaryColor,
                      ),
                      child: Center(
                        child: Text(
                          // widget.images[index].isFollowing
                          //     ? "Following"
                          //     :
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
      
        ],
      ),
      bottomNavigationBar: InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: CustomButton(label: "Save")),
    );
  }
}
   // CustomArtistVerticalList(
                  //   images: Images().artistPrefList,
                  // ),