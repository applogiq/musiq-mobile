import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:musiq/src/view/pages/home/components/pages/recently_played_view_all.dart';

import '../../widgets/empty_box.dart';


class HomeView extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeView> with SingleTickerProviderStateMixin {
  bool _isAppbar = true;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        appBarStatus(false);
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        appBarStatus(true);
      }
    });
  }

  void appBarStatus(bool status) {
    setState(() {
      _isAppbar = status;
    });
  }

  load() {
    print("fsdfd");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(_isAppbar?240:80),
        //   child: _isAppbar?PrimaryAppBar(isNetworkImage: true, imageURL: "https://images.squarespace-cdn.com/content/56454c01e4b0177ad4141742/1458827328980-JNJHPFWPV4288CAJ8R5T/Covers-Vol.-1-Cover.jpg?content-type=image%2Fjpeg", title: "title", height: 240.0, count: 3):SecondaryAppBar(title: "title"),
        // ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                bottom: PreferredSize(
                  preferredSize: Size(MediaQuery.of(context).size.width, 80),
                  child: SecondaryAppBar(title: "D"),
                ),
                expandedHeight: 300.0,
                pinned: true,
                leadingWidth: 0.0,
                leading: EmptyBox(),
                floating: true,
                excludeHeaderSemantics: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: PrimaryAppBar(
                        callback: load,
                        isNetworkImage: true,
                        imageURL:
                            'https://images.squarespace-cdn.com/content/5aee389b3c3a531e6245ae76/1530965251082-9L40PL9QH6PATNQ93LUK/linkedinPortraits_DwayneBrown08.jpg?format=1000w&content-type=image%2Fjpeg',
                        title: "title",
                        height: 250.0,
                        count: 3)
                    // background:Image.network( 'https://images.squarespace-cdn.com/content/5aee389b3c3a531e6245ae76/1530965251082-9L40PL9QH6PATNQ93LUK/linkedinPortraits_DwayneBrown08.jpg?format=1000w&content-type=image%2Fjpeg', fit: BoxFit.cover,),
                    ),
              ),
            ];
          },
          body: Center(
            child: Text(
              "This is body",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        // ListView.builder(
        //   controller: _scrollController,
        //   itemCount: 20,
        //   itemBuilder: (BuildContext context, int index) {
        //     return container();
        //   },
        // ),
      ),
    );
  }
}

Widget container() {
  return Container(
    height: 80.0,
    color: Colors.pink,
    margin: EdgeInsets.all(8.0),
    width: 100,
    child: Center(
        child: Text(
      'Container',
      style: TextStyle(
        fontSize: 18.0,
      ),
    )),
  );
}

class CustomAppBar extends StatefulWidget {
  @override
  AppBarView createState() => new AppBarView();
}

class AppBarView extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: InkWell(
        onTap: () => {},
        child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.network(
                  'https://images.squarespace-cdn.com/content/5aee389b3c3a531e6245ae76/1530965251082-9L40PL9QH6PATNQ93LUK/linkedinPortraits_DwayneBrown08.jpg?format=1000w&content-type=image%2Fjpeg'),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
          alignment: Alignment.centerLeft,
          icon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ],
      title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Custom Appbar",
            style: TextStyle(color: Colors.black),
          )),
    );
  }
}
