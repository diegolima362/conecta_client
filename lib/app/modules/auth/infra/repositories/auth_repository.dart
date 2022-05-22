import 'package:fpdart/fpdart.dart';

import '../../domain/entities/user_info.dart';
import '../../domain/errors/errors.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/types/types.dart';
import '../datasources/auth_datasource.dart';

class AuthRepository implements IAuthRepository {
  final IAuthDatasource dataSource;

  AuthRepository(this.dataSource);

  @override
  Future<EitherLoggedInfo> signInWithUserAndPassword(
      String user, String password) async {
    try {
      var loggedUser =
          await dataSource.signInWithUserAndPassword(user, password);
      return Right(Option.of(loggedUser));
    } on AuthFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherLoggedInfo> signUp(UserInfo user) async {
    try {
      var loggedUser = await dataSource.signUp(user);
      return Right(Option.of(loggedUser));
    } on AuthFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherLoggedInfo> loggedUser() async {
    try {
      final result = await dataSource.getCurrentUser();
      return Right(result);
    } on AuthFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherLoggedInfo> logout() async {
    try {
      await dataSource.logout();
      return Right(Option.none());
    } on AuthFailure catch (e) {
      return Left(e);
    }
  }
}
