import '../repositories/auth_repository.dart';
import '../types/types.dart';

abstract class IGetUserToken {
  Future<EitherToken> call({bool refresh = false});
}

class GetUserToken implements IGetUserToken {
  final IAuthRepository repository;

  GetUserToken(this.repository);

  @override
  Future<EitherToken> call({bool refresh = false}) async =>
      await repository.getUserToken(refresh: refresh);
}
