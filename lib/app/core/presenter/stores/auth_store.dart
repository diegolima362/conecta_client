import 'package:asuka/asuka.dart';
import 'package:conecta/app/modules/auth/domain/entities/user_entity.dart';

import '../../../modules/auth/domain/usecases/usecases.dart';

abstract class IAuthStore {
  bool get isLogged;

  UserEntity? get user;

  Future<void> checkLogin();

  void setUser(UserEntity? user);

  Future signOut();
}

class AuthStore implements IAuthStore {
  final IGetLoggedUser getLoggedUser;
  final ILogout logout;

  UserEntity? _user;

  AuthStore(this.getLoggedUser, this.logout);

  @override
  bool get isLogged => _user != null;

  @override
  UserEntity? get user => _user;

  @override
  Future<void> checkLogin() async {
    var result = await getLoggedUser();
    return result.fold(
      (l) => AsukaSnackbar.warning(l.message),
      (u) => _user = u.toNullable(),
    );
  }

  @override
  void setUser(UserEntity? user) => _user = user;

  @override
  Future signOut() async {
    var result = await logout();
    result.fold((l) {
      AsukaSnackbar.alert(l.message.split(':').last.trim()).show();
    }, (r) {
      _user = null;
    });
  }
}
