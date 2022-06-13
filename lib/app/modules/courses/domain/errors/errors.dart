import 'package:conecta/app/core/domain/errors/erros.dart';

abstract class CoursesFailure implements AppContentFailure {
  @override
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class AlertFailure implements CoursesFailure {
  @override
  final String message;
  AlertFailure({this.message = ''});
}

class GetCoursesError implements CoursesFailure {
  @override
  final String message;
  GetCoursesError({this.message = ''});
}
