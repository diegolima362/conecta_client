import 'package:asuka/asuka.dart' as asuka;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/presenter/stores/auth_store.dart';
import '../../../../core/presenter/widgets/widgets.dart';
import '../../domain/entities/user_info.dart';
import '../../domain/errors/errors.dart';
import '../../domain/usecases/usecases.dart';

class LoginStore extends NotifierStore<AuthFailure, Unit> {
  final ISignInWithUserAndPassword signInUsecase;
  final ISignUp signUpUsecase;

  final AuthStore authStore;

  LoginStore({
    required this.signInUsecase,
    required this.signUpUsecase,
    required this.authStore,
  }) : super(unit);

  Future<Unit> signInWithUserAndPassword(String user, String password) async {
    final entry = loadingOverlay;

    asuka.addOverlay(entry);

    var result = await signInUsecase(user, password);

    entry.remove();

    result.fold((failure) {
      asuka.showSnackBar(
        SnackBar(content: Text(failure.message)),
      );
    }, (user) {
      asuka.showSnackBar(const SnackBar(content: Text('Bem-vindo')));
      authStore.setUser(user.toNullable());
      Modular.to.navigate('/');
    });

    return unit;
  }

  Future<Unit> signUp(UserInfo userInfo) async {
    final entry = loadingOverlay;

    asuka.addOverlay(entry);

    var result = await signUpUsecase(userInfo);

    entry.remove();

    result.fold((failure) {
      asuka.showSnackBar(
        SnackBar(content: Text(failure.message)),
      );
    }, (user) {
      asuka.showSnackBar(const SnackBar(content: Text('Bem-vindo')));
      authStore.setUser(user.toNullable());
      Modular.to.navigate('/');
    });

    return unit;
  }
}
