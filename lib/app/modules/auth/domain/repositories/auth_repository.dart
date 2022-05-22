import '../entities/user_info.dart';
import '../types/types.dart';

abstract class IAuthRepository {
  Future<EitherLoggedInfo> signInWithUserAndPassword(
    String user,
    String password,
  );

  Future<EitherLoggedInfo> signUp(UserInfo userInfo);

  Future<EitherLoggedInfo> loggedUser();

  Future<EitherToken> getUserToken({bool refresh = false});

  Future<EitherLoggedInfo> logout();
}
