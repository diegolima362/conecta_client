import 'package:fpdart/fpdart.dart';

import '../errors/errors.dart';
import '../repositories/auth_repository.dart';
import '../types/types.dart';

abstract class ISignInWithUserAndPassword {
  Future<EitherLoggedInfo> call(String user, String password);
}

class SignInWithUserAndPassword implements ISignInWithUserAndPassword {
  final IAuthRepository repository;

  SignInWithUserAndPassword(this.repository);

  @override
  Future<EitherLoggedInfo> call(String user, String password) async {
    if (user.isEmpty || password.isEmpty) {
      return Left(ErrorLoginEmail(message: "Email inválido Email"));
    }

    return await repository.signInWithUserAndPassword(user, password);
  }
}
