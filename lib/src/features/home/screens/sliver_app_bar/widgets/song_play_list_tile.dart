import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common_widgets/container/custom_color_container.dart';
import '../../../../../core/constants/constant.dart';
import '../../../../search/provider/search_provider.dart';

class SongPlayListTile extends StatelessWidget {
  const SongPlayListTile({
    super.key,
    required this.imageUrl,
    required this.songName,
    required this.musicDirectorName,
    required this.songId,
    required this.albumName,
    required this.isAdded,
    required this.playlistId,
  });

  final String albumName;
  final String imageUrl;
  final bool isAdded;
  final String musicDirectorName;
  final int songId;
  final int playlistId;
  final String songName;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: CustomColor.bg,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CustomColorContainer(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context
                              .read<SearchProvider>()
                              .addSongToPlaylist(songId, playlistId);
                        },
                        child: Image.network(
                          imageUrl,
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      isAdded
                          ? Positioned.fill(
                              child: ColoredBox(
                                  color: Colors.black.withOpacity(0.8),
                                  child: const Icon(Icons.check)))
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<SearchProvider>()
                        .addSongToPlaylist(songId, playlistId);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songName,
                          style: fontWeight400(),
                        ),
                        Text(
                          musicDirectorName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: fontWeight400(
                              size: 12.0, color: CustomColor.subTitle),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              isAdded
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          context
                              .read<SearchProvider>()
                              .addSongToPlaylist(songId, playlistId);
                        },
                      ),
                    )
            ],
          ),
        ));
  }
}
