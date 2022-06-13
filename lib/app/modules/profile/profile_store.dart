import 'package:conecta/app/modules/auth/domain/entities/user_entity.dart';
import 'package:conecta/app/modules/auth/domain/errors/errors.dart';
import 'package:conecta/app/modules/auth/domain/usecases/get_logged_user.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class ProfileStore extends NotifierStore<AuthFailure, Option<UserEntity>> {
  final IGetLoggedUser usecase;

  ProfileStore(this.usecase) : super(none());

  Future<Unit> getData() async {
    update(none());

    setLoading(true);

    final result = await usecase();

    setLoading(false);

    result.fold(setError, update);

    return unit;
  }
}
