import 'package:flutter/material.dart';

import '../../../core/constants/constant.dart';
import '../provider/artist_provider.dart';

class FollowAndUnfollowButton extends StatelessWidget {
  const FollowAndUnfollowButton({
    Key? key,
    required this.provider,
    required this.index,
  }) : super(key: key);
  final ArtistPreferenceProvider provider;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: provider.userFollowedArtist
                    .contains(provider.artistModel!.records[index].artistId)
                ? 12
                : 16,
            vertical: 4),
        child: InkWell(
          onTap: () async {
            provider.checkFollow(
                provider.artistModel!.records[index], index, context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: provider.userFollowedArtist
                        .contains(provider.artistModel!.records[index].artistId)
                    ? 12
                    : 10,
                vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: provider.userFollowedArtist
                      .contains(provider.artistModel!.records[index].artistId)
                  ? CustomColor.followingColor
                  : CustomColor.secondaryColor,
            ),
            child: Center(
              child: Text(
                provider.userFollowedArtist
                        .contains(provider.artistModel!.records[index].artistId)
                    ? "Unfollow"
                    : "Follow",
                style: fontWeight400(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
