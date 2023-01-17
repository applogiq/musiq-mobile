import 'package:flutter/material.dart';

class AlbumInfo extends StatelessWidget {
  const AlbumInfo({
    Key? key,
    required this.infoBoxHeight,
  }) : super(key: key);

  final double infoBoxHeight;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black87,
              ],
              stops: [
                0.00022,
                1.0,
              ]),
        ),
        child: SizedBox(
          height: infoBoxHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "=",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      backgroundImage: NetworkImage(
                          "https://i.scdn.co/image/ab6761610000e5eb12a2ef08d00dd7451a6dbed6"),
                    ),
                    Text(
                      "Ed Sheeran",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox.shrink()
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Album . 2021",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.download_outlined,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            color: Colors.white,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
