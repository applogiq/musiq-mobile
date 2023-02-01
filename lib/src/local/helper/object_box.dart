import '../../../objectbox.g.dart';
import '../model/user_model.dart';

class ObjectBox {
  ObjectBox._init(this._store) {
    _userBox = Box<User>(_store);
  }

  late final Store _store;
  late final Box<User> _userBox;

  static Future<ObjectBox> init() async {
    final store = await openStore();

    return ObjectBox._init(store);
  }

  User? getUser(int id) => _userBox.get(id);

  Stream<List<User>> getUsers() => _userBox
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());

  int insertUser(User user) => _userBox.put(user);

  bool deleteUser(int id) => _userBox.remove(id);

  Future<List<User>> getAll() async {
    return _userBox.getAll();
  }

  Future clearUser() async {
    return _userBox.removeAll();
  }
}
