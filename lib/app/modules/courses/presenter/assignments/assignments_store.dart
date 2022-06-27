import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:conecta/app/modules/courses/domain/usecases/usecases.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class AssignmentsStore
    extends NotifierStore<AppContentFailure, List<AssignmentEntity>> {
  final IGetCourseAssignments getAssignments;

  AssignmentsStore(this.getAssignments) : super([]);

  Future<Unit> getData(int courseId) async {
    final result = await getAssignments(courseId);

    result.fold(setError, update);
    return unit;
  }
}
