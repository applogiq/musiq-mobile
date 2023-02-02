import 'dart:io';

import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../objectbox.g.dart';
import '../../../../local/model/favourite_model.dart';
import '../../../../local/model/queue_model.dart';

extension PlayerLocalDatabaseController on PlayerProvider {
  removeAllData() async {
    await getApplicationDocumentsDirectory().then((Directory dir) {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/');
      final favouriteBox = store.box<FavouriteSong>();
      final queueBox = store.box<SongListModel>();
      favouriteBox.removeAll();
      queueBox.removeAll();
      store.close();
    });
  }
}
