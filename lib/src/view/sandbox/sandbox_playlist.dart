import 'package:flutter/material.dart';

class SandPlaylistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              pinned: true,
              leading: Icon(Icons.arrow_back),
              expandedHeight: 200.0,
              flexibleSpace: const FlexibleSpaceBar(
                background: FlutterLogo(),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 28.0,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1547721064-da6cfb341d50'),
                  ),
                )
              ]),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  // color: index.isOdd ? Colors.white : Colors.black12,
                  height: 100.0,
                  child: Center(
                    child: Text('$index', textScaleFactor: 5),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
