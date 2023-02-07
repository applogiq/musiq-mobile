import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color.dart';
import '../provider/artist_provider.dart';

class ArtistInfo extends StatelessWidget {
  const ArtistInfo({super.key, required this.provider, required this.index});
  final ArtistPreferenceProvider provider;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.artistModel!.records[index].artistName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
            Row(
              children: [
                const Icon(Icons.people),
                const SizedBox(
                  width: 8,
                ),
                Consumer<ArtistPreferenceProvider>(
                  builder: (context, pro, _) {
                    return Text(
                      pro.artistModel!.records[index].followers != null
                          ? pro.artistModel!.records[index].followers.toString()
                          : "0",
                      style: TextStyle(
                          color: CustomColor.subTitle,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
