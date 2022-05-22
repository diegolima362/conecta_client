import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../errors/erros.dart';

typedef EitherWorkUnit = Either<WorkerFailure, Unit>;

typedef EitherStreamBool = Either<ConnectivityFailure, Stream<bool>>;

typedef EitherConnectivityBool = Either<ConnectivityFailure, bool>;

typedef EitherImage = Either<ImageServiceFailure, Option<Uint8List>>;

typedef EitherCached = Either<ImageServiceFailure, Unit>;
