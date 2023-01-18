import 'package:musiq/src/features/home/domain/model/collection_view_all_model.dart';

class PlayerModel {
  final List songList;
  final int selectedSongIndex;
  final CollectionViewAllModel collectionViewAllModel;

  PlayerModel(
      {required this.songList,
      required this.selectedSongIndex,
      required this.collectionViewAllModel});
}
