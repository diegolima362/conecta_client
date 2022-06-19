import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/modules/courses/domain/usecases/join_course.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class JoinStore extends NotifierStore<AppContentFailure, Unit> {
  final IJoinCourse joinCourse;

  JoinStore(this.joinCourse) : super(unit);

  Future<Unit> join(String code) async {
    setLoading(true);
    final result = await joinCourse(code.toUpperCase());
    setLoading(false);

    result.fold(setError, (r) => update(unit));
    return unit;
  }
}
