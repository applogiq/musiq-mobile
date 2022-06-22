import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musiq/src/logic/services/api_call.dart';
import 'package:musiq/src/logic/services/api_route.dart';
import 'package:musiq/src/model/api_model/artist_model.dart';
import 'package:musiq/src/model/api_model/song_list_model.dart';
import 'package:musiq/src/view/pages/home/components/pages/view_all_screen.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';

import '../../../../../helpers/constants/api.dart';
import '../../../../widgets/custom_color_container.dart';
import 'horizontal_list_view.dart';

class ArtistListView extends StatelessWidget {
   ArtistListView({
    Key? key,
    required this.artist,
  }) : super(key: key);

  final ArtistModel artist;
  APICall apiCall=APICall();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
          child: ListHeaderWidget(
            title: "Artists",
            actionTitle: "View All",
            isArtist: true,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 4),
          height: 300,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: artist.records.length,
              itemBuilder: (context, index) => Row(
                    children: [
                      index == 0
                          ? SizedBox(
                              width: 12,
                             
                            )
                          : SizedBox(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: InkWell(
                          onTap: ()async{
                             Map<String, String> queryParams = {
  'artist_id': artist.records[index].id.toString(),
  'skip': '0',
  'limit': '100',
};
 var urlSet="${APIConstants.BASE_URL}songs?artist_id=${queryParams["artist_id"]}&skip=${queryParams["skip"]}&limit=${queryParams["limit"]}";
                        var res= await apiCall.getRequestWithAuth(urlSet);
                        print(res.statusCode);
                        if(res.statusCode==200){
                          var data=jsonDecode(res.body);
                          SongList songList=SongList.fromMap(data);
                          print(songList.toMap());
                              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ViewAllScreen(songList: songList,title: artist.records[index].name,
                            imageURL: artist.records[index].isImage? APIConstants.BASE_IMAGE_URL+artist.records[index].artistId+".png":
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/450px-No_image_available.svg.png",
                            
                            )));
                        }
                        else{

                        }
                            // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ViewAllScreen(title: artist.records[index].name,
                            // imageURL: artist.records[index].isImage? APIConstants.BASE_IMAGE_URL+artist.records[index].artistId+".png":
                            //       "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/450px-No_image_available.svg.png",
                            
                            // )));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomColorContainer(
                                child: Image.network(
                                  artist.records[index].isImage? APIConstants.BASE_IMAGE_URL+artist.records[index].artistId+".png":
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/450px-No_image_available.svg.png",
                            
                                  height: 240,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                artist.records[index].name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                  
                    ],
                  )),
        )
      ],
    );
  }
}
