// import '../../../objectbox.g.dart';
// import '../model/favourite_model.dart';

// class FavouriteSongBox {
//   late final Store _store;
//   late final Box<FavouriteSong> _favouriteBox;

//   FavouriteSongBox._init(this._store) {
//     _favouriteBox = Box<FavouriteSong>(_store);
//   }
//   FavouriteSongBox._closeStore() {
//     _favouriteBox.removeAll();
//     // _store.close();
//   }
//   static Future<FavouriteSongBox> init() async {
//     try {
//       final store = await openStore();

//       return FavouriteSongBox._init(store);
//     } catch (e) {
//       debugPrint(e.toString());

//       FavouriteSongBox._closeStore();
//       return FavouriteSongBox.init();
//     }
//   }

//   FavouriteSongBox(var boxStore)
//       : _favouriteBox = boxStore.box<FavouriteSong>();

//   Future<void> add(FavouriteSong song) async {
//     _favouriteBox.put(song);
//   }

//   Stream<List<FavouriteSong>> getFavourites() => _favouriteBox
//       .query()
//       .watch(triggerImmediately: true)
//       .map((query) => query.find());

//   Future<void> delete(FavouriteSong song) async {
//     _favouriteBox.remove(song.songUniqueId);
//   }
// }
