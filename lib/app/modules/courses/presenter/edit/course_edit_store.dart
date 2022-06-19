import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/modules/courses/domain/entities/course_entity.dart';
import 'package:conecta/app/modules/courses/domain/usecases/usecases.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class CourseEditStore
    extends NotifierStore<AppContentFailure, Option<CourseEntity>> {
  final ICreateCourse createCourse;
  final IEditCourse editCourse;
  final IGetCourseById getCourseById;

  CourseEditStore(this.createCourse, this.editCourse, this.getCourseById)
      : super(none());

  Future<Unit> create(String title, int professorId) async {
    final result = await createCourse(CourseEntity(
      code: '',
      id: 0,
      professorId: professorId,
      professorName: '',
      name: title,
    ));

    result.fold(setError, (r) {});
    return unit;
  }

  Future<Unit> edit(String title) async {
    if (state.isNone()) {
      return unit;
    }

    final old = state.toNullable()!;

    final course = CourseEntity(
      id: old.id,
      name: title,
      professorName: old.professorName,
      professorId: old.professorId,
      code: old.code,
    );

    final result = await editCourse(course);

    result.fold(setError, (r) => update(Option.of(course)));

    return unit;
  }

  Future<Unit> getData(int courseId) async {
    final result = await getCourseById(courseId);

    result.fold(setError, update);

    return unit;
  }
}
