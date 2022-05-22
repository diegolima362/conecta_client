import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../infra/models/user_model.dart';

class SecureStorage {
  final SharedPreferences storage;

  SecureStorage(this.storage);

  Future<Option<UserModel>> getUser() async {
    final json = storage.getString('user');
    return json == null ? none() : some(UserModel.fromJson(json));
  }

  Future<Unit> saveUser(UserModel user) async {
    await storage.setString('user', user.toJson());
    return unit;
  }

  Future<Unit> clear() async {
    await storage.remove('user');
    return unit;
  }
}
