import '../entities/user_info.dart';
import '../repositories/auth_repository.dart';
import '../types/types.dart';

abstract class ISignUp {
  Future<EitherLoggedInfo> call(UserInfo userInfo);
}

class SignUp implements ISignUp {
  final IAuthRepository repository;

  SignUp(this.repository);

  @override
  Future<EitherLoggedInfo> call(UserInfo userInfo) async {
    return await repository.signUp(userInfo);
  }
}
