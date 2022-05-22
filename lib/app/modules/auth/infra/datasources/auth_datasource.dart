import 'package:fpdart/fpdart.dart';

import '../../domain/entities/user_info.dart';
import '../models/user_model.dart';

abstract class IAuthDatasource {
  Future<UserModel> signInWithUserAndPassword(
    String user,
    String password,
  );

  Future<UserModel> signUp(UserInfo userInfo);

  Future<Option<UserModel>> getCurrentUser();

  Future<Unit> logout();

  Option<String> getUserToken();

  Future<Option<String>> refreshToken();
}
