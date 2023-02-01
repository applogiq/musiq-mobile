import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/style.dart';
import '../../../home/provider/artist_view_all_provider.dart';
import '../../../view_all/domain/model/player_model.dart';
import '../reorder_list_tile.dart';

class UpNextExpandable extends StatelessWidget {
  const UpNextExpandable({
    Key? key,
    required this.playerModel,
  }) : super(key: key);

  final PlayerModel playerModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 40,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(33, 33, 44, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: const UpNext(),
            trailing: InkWell(
                onTap: () {
                  context.read<ArtistViewAllProvider>().toggleUpNext();
                  // songController.isBottomSheetView.toggle();
                },
                child: const Icon(Icons.keyboard_arrow_down_rounded)),
          ),
          ReorderListUpNextSongTile(
              playScreenModel: playerModel.collectionViewAllModel, index: 0)
        ],
      ),
    );
  }
}

class UpNext extends StatelessWidget {
  const UpNext({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Up next",
      style: fontWeight500(size: 16.0),
    );
  }
}
