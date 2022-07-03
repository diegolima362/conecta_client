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

class RemoteCoursesError implements CoursesFailure {
  @override
  final String message;
  RemoteCoursesError({this.message = ''});
}

class RemoteAssignmentsError implements CoursesFailure {
  @override
  final String message;
  RemoteAssignmentsError({this.message = ''});
}

class RemoteFeedError implements CoursesFailure {
  @override
  final String message;
  RemoteFeedError({this.message = ''});
}
