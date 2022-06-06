import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen(
      {Key? key,
      required this.imageURL,
      required this.songName,
      required this.artistName})
      : super(key: key);
  final String imageURL;
  final String songName;
  final String artistName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(imageURL), fit: BoxFit.cover)),
              child: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [
                        0.1,
                        0.99
                      ],
                          colors: [
                        Color.fromRGBO(22, 21, 28, 0),
                        Color.fromRGBO(22, 21, 28, 1),
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded),
                      Icon(Icons.more_vert_rounded)
                    ],
                  ),
                )
              ]),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [Text(songName), Text(artistName)],
            ),
          ),
        ],
      ),
    );
  }
}
