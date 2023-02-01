import '../../../home/domain/model/collection_view_all_model.dart';

class PlayerModel {
  PlayerModel(
      {required this.songList,
      required this.selectedSongIndex,
      required this.collectionViewAllModel});

  final CollectionViewAllModel collectionViewAllModel;
  final int selectedSongIndex;
  final List songList;
}
