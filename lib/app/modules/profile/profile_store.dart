import 'package:conecta/app/core/external/drivers/fpdart_either_adapter.dart';
import 'package:conecta/app/modules/auth/domain/entities/user_entity.dart';
import 'package:conecta/app/modules/auth/domain/errors/errors.dart';
import 'package:conecta/app/modules/auth/domain/usecases/get_logged_user.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class ProfileStore extends NotifierStore<AuthFailure, Option<UserEntity>> {
  final IGetLoggedUser usecase;

  ProfileStore(this.usecase) : super(none());

  Unit getData() {
    executeEither(() => FpdartEitherAdapter.adapter(usecase()));
    return unit;
  }
}
