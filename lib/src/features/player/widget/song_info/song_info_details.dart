import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/box/vertical_box.dart';
import '../../../../constants/constant.dart';
import '../../../../utils/time.dart';
import '../../provider/player_provider.dart';
import 'song_info.dart';

class SongInfoLabelDetails extends StatelessWidget {
  const SongInfoLabelDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            context
                .read<PlayerProvider>()
                .songInfoModel!
                .records
                .albumDetails
                .albumName,
            style:
                fontWeight400(size: 16.0, color: Colors.white.withOpacity(0.6)),
          ),
          SongInfoLabelInfo(
            label: "Duration:",
            value:
                " ${detailedDuration(" ${context.read<PlayerProvider>().songInfoModel!.records.duration}")}",
          ),
          SongInfoLabelInfo(
            label: "Release:",
            value:
                " ${context.read<PlayerProvider>().songInfoModel!.records.albumDetails.releasedYear}",
          ),
          SongInfoLabelInfo(
            label: "Label:",
            value:
                " ${context.read<PlayerProvider>().songInfoModel!.records.label}",
          ),
          const VerticalBox(height: 24),
          Text(
            "Artists",
            style: fontWeight600(),
          ),
          const SongInfoArtistListView(),
        ],
      ),
    );
  }
}
