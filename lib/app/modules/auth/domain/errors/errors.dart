import 'package:conecta/app/core/domain/errors/erros.dart';

abstract class AuthFailure implements AppContentFailure {
  @override
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class AuthConnectionError extends AuthFailure {
  @override
  final String message;
  AuthConnectionError({required this.message});
}

class ErrorWrongCrendentials extends AuthFailure {
  @override
  final String message;
  ErrorWrongCrendentials({required this.message});
}

class ErrorLoginEmail extends AuthFailure {
  @override
  final String message;
  ErrorLoginEmail({required this.message});
}

class ErrorGuestSignIn extends AuthFailure {
  @override
  final String message;
  ErrorGuestSignIn({required this.message});
}

class ErrorGetLoggedUser extends AuthFailure {
  @override
  final String message;
  ErrorGetLoggedUser({this.message = 'Erro ao recuperar usuario'});
}

class ErrorGetToken extends AuthFailure {
  @override
  final String message;
  ErrorGetToken({this.message = 'Erro ao recuperar token'});
}

class ErrorRefreshToken extends AuthFailure {
  @override
  final String message;
  ErrorRefreshToken({this.message = 'Erro ao atualizar token'});
}

class ErrorLogout extends AuthFailure {
  @override
  final String message;
  ErrorLogout({required this.message});
}

class InternalError implements AuthFailure {
  @override
  final String message;
  InternalError({required this.message});
}
