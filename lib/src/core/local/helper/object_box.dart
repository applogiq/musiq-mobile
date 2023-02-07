import 'package:musiq/src/core/local/model/user_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../objectbox.g.dart';
import '../model/favourite_model.dart';
import '../model/queue_model.dart';
import '../model/search_model.dart';

class ObjectBox {
  late final Store store;

  late final Box<FavouriteSong> favouriteBox;
  late final Box<SongListModel> songListBox;
  late final Box<SearchArtistLocalModel> searchArtistBox;
  late final Box<SearchSongLocalModel> searchSongBox;
  late final Box<User> userBox;

  ObjectBox._create(this.store) {
    favouriteBox = Box<FavouriteSong>(store);
    songListBox = Box<SongListModel>(store);
    searchSongBox = Box<SearchSongLocalModel>(store);
    searchArtistBox = Box<SearchArtistLocalModel>(store);
    userBox = Box<User>(store);
  }
  static Future<ObjectBox> create() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final databaseDirectory = p.join(documentsDirectory.path, "musiq");
    final store = await openStore(directory: databaseDirectory);
    return ObjectBox._create(store);
  }

  void saveFavourite(FavouriteSong favouriteSong) {
    favouriteBox.put(favouriteSong);
  }

  Stream<List<FavouriteSong>> getFavourites() {
    final qFavourite = favouriteBox.query();

    return qFavourite
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  void addQueue(SongListModel songListModel) {
    songListBox.put(songListModel);
  }

  void addNewSongListQueue(List<SongListModel> songListModels) {
    removeAllQueueSong();
    songListBox.putMany(songListModels);
    getAllQueueSong();
  }

  void addSongListQueue(List<SongListModel> songListModels) {
    songListBox.putMany(songListModels);
    getAllQueueSong();
  }

  void removeAllQueueSong() {
    songListBox.removeAll();
  }

  getAllQueueSong() {
    var songList = songListBox.getAll();
    return songList;
    // for (var e in songList) {
    //   debugPrint(e.title);
    // }
  }

  addSongSearch(String searchData) {
    searchSongBox.put(SearchSongLocalModel(searchName: searchData));
  }

  removeSongSearch(String searchData) {
    var res = searchSongBox.getAll();
    for (var element in res) {
      if (element.searchName == searchData.trim()) {
        searchSongBox.remove(element.id);
      }
    }
  }

  removeAllSongSearch() {
    searchSongBox.removeAll();
  }

  Stream<List<SearchSongLocalModel>> getSongSearch() {
    final qBuilderSongSearch = searchSongBox.query();

    return qBuilderSongSearch
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  addArtistSearch(String searchData) {
    searchArtistBox.put(SearchArtistLocalModel(searchName: searchData));
  }

  removeArtistSearch(String searchData) {
    var res = searchArtistBox.getAll();
    for (var element in res) {
      if (element.searchName == searchData.trim()) {
        searchArtistBox.remove(element.id);
      }
    }
  }

  removeAllArtistSearch() {
    searchArtistBox.removeAll();
  }

  Stream<List<SearchArtistLocalModel>> getArtistSearch() {
    final qBuilderArtistSearch = searchArtistBox.query();

    return qBuilderArtistSearch
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
