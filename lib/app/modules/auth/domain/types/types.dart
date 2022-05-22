import 'package:fpdart/fpdart.dart';

import '../entities/user_entity.dart';
import '../errors/errors.dart';

typedef EitherLoggedInfo = Either<AuthFailure, Option<UserEntity>>;

typedef EitherToken = Either<AuthFailure, Option<String>>;
